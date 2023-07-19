@tool
extends Button

@export var url : String = "http://127.0.0.1:7860"

@export var prompt : String = "Cute puppy"
@export var steps : int = 50

@export var texture_rect : TextureRect
@export var scene : Node3D

var requestNode

# config: SD_Config

func generate_from_data() -> void:
	# create request to the stable diffusion api
	var api_url = url + "/sdapi/v1/txt2img"
	var json = generateJsonFromData()
	var headers = ["Content-Type: application/json"]
	requestNode.request(api_url, headers, HTTPClient.METHOD_POST, json)
	
	# create texture from image and add it to root
	#var texture = ImageTexture.create_from_image(scene.get_edge_texture())
	#texture_rect.texture = texture


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
	texture_rect.texture = texture

func generateJsonFromData():
	var dataAsJson = JSON.new().stringify({
		"prompt": prompt,
		"steps": steps,
		"width": 640,
		"height": 360,
#		"seed": 1246581,
		"alwayson_scripts": {
			"controlnet": {
				"args": [
					{
						#"input_image": encodeBase64(depth_image.get_image()),
						"input_image": encodeBase64(scene.get_edge_texture()),
						#"module": "depth",
						#"model": "control_v11f1p_sd15_depth [cfd03158]"
						"module": "canny",
						"model": "control_v11p_sd15_canny [d14c016b]"
					}
				]
			}
		}
	})
	return dataAsJson

func encodeBase64(data: Image):
	var buffer_data = data.save_png_to_buffer()
	var encoded_string = ""
	var encoded_array = []
	
	var counter = 0
	for i in range(buffer_data.size() / 3):
		
		# create a 24 bit number from three values
		var long_byte = 0b0
		var padding = 0
		if buffer_data.size() < (counter + 1):
			long_byte = long_byte | (buffer_data[counter] << 16)
			padding = 2
		elif buffer_data.size() < (counter + 2):
			long_byte = long_byte | (buffer_data[counter] << 16) | (buffer_data[counter + 1] << 8)
			padding = 1
		else:
			long_byte = long_byte | (buffer_data[counter] << 16) | (buffer_data[counter + 1] << 8) | (buffer_data[counter + 2])
		
		# Add the four chars to the encoded string
		encoded_array.append(SD_Renderer.to_b64_database[((long_byte & (0b111111 << 18)) >> 18)])
		encoded_array.append(SD_Renderer.to_b64_database[((long_byte & (0b111111 << 12)) >> 12)])
		if padding == 2:
			#encoded_string += "=="
			encoded_array.append("=")
			encoded_array.append("=")
		else:
			encoded_array.append(SD_Renderer.to_b64_database[((long_byte & (0b111111 << 6)) >> 6)])
			if padding == 1:
				#encoded_string += "="
				encoded_array.append("=")
			else:
				encoded_array.append(SD_Renderer.to_b64_database[(long_byte & 0b111111)])
		
		counter += 3
	
	encoded_string = "".join(PackedStringArray(encoded_array))
	return encoded_string

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
				bin_buffer.append(SD_Renderer.from_b64_database[char])
			else:
				bin_buffer.append(0b000000)
		
		# create a number with lenght of 24 (4 * 6 or 3 * 8)
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
	#print(texture)
