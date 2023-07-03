@tool
extends Button

@export var url : String = "http://127.0.0.1:7860"

@export var prompt : String = "Cute puppy"
@export var steps : int = 50

var requestNode

# config: SD_Config

func generate_from_data() -> void:
	# create request to the stable diffusion api
	var api_url = url + "/sdapi/v1/txt2img"
	var json = generateJsonFromData()
	var headers = ["Content-Type: application/json"]
	requestNode.request(api_url, headers, HTTPClient.METHOD_POST, json)


func _on_request_completed(result, response_code, headers, body):
	# print data
	print("Result: ", result)
	print("Response Code: ", response_code)
	print("Header: ", headers)
	
	# create json object from body
	var json_object = JSON.new()
	json_object.parse(body.get_string_from_utf8())
	var response = json_object.get_data()
	
	# decode base64 encoded image
	var data = decodeBase64(response["images"][0])
	
	# create image from decoded buffer
	var image = Image.new()
	var error = image.load_png_from_buffer(data)
	if error != OK:
		push_error("Couldn't load image")
	
	# create texture from image and add it to root
	var texture = ImageTexture.create_from_image(image)
	#print(texture)
	var texture_rect = TextureRect.new()
	get_node("/root").add_child(texture_rect)
	texture_rect.texture = texture

func generateJsonFromData():
	var dataAsJson = JSON.new().stringify({
		"prompt": prompt,
		"steps": steps
	})
	return dataAsJson


# Decodes base64 encoded data represented as a string
# Returns a PackedByteArray with the decoded utf8 bytes
func decodeBase64(data: String):
	var final_buffer = []
	var counter = 0
	for i in range(data.length() / 4):
		var sub_data = data.substr(counter, 4)
		var paddingCounter = sub_data.count("=")
		
		# get binary representation of base64 encoded values
		var bin_buffer = []
		for char in sub_data:
			if char != "=":
				bin_buffer.append(SD_Renderer.b64_database[char])
			else:
				bin_buffer.append(0b000000)
		
		# create a number with lenght of 24
		var bin_number = 0b0
		for idx in range(bin_buffer.size()):
			var b = (bin_buffer[idx] << (18 - (idx * 6)))
			bin_number = bin_number | b
		
		# get decoded values in binary
		var v1 = ((bin_number & (0b11111111 << 16)) >> 16)
		var v2 = ((bin_number & (0b11111111 << 8)) >> 8)
		var v3 = bin_number & 0b11111111
		
		# add values to final buffer (keep base64 padding in mind)
		final_buffer.append(v1)
		if paddingCounter < 2:
			final_buffer.append(v2)
		if paddingCounter < 1:
			final_buffer.append(v3)
		
		counter += 4
	
	return PackedByteArray(final_buffer)


func _ready():
	requestNode = HTTPRequest.new()
	add_child(requestNode)
	requestNode.request_completed.connect(_on_request_completed)

func _enter_tree():
	pressed.connect(generate_from_data)
