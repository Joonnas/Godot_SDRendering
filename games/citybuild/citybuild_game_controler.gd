extends Node
class_name Citybuild_Controler

enum HouseTypes {SMALL_HOUSE, BIG_HOUSE, SKYSCRAPER, EMPTY = -1}

const small_house_scene = preload("res://games/citybuild/small_house.tscn")

var field = [
	[HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY],
	[HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY],
	[HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY],
	[HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY],
	[HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY, HouseTypes.EMPTY]
]
const field_size = 10

var place_house := false
var place_house_type := HouseTypes.EMPTY
var gold_to_spend := 0

var gold_amount = 0 :
	get:
		return gold_amount
	set(value):
		gold_amount = value
		get_node("../Interface/VBoxContainer/Label").text = "Gold: " + var_to_str(gold_amount)

func _ready():
	gold_amount = 2000 


func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("toggle_game_interface"):
		get_node("../Interface").visible = !get_node("../Interface").visible


func add_house(position: Vector2i, house_type: HouseTypes):
	field[position.x][position.y] = house_type
	gold_amount -= gold_to_spend
	
	set_placeable_fields_visible(false)
	place_house = false
	place_house_type = HouseTypes.EMPTY
	gold_to_spend = 0
	
	var instance
	if house_type == HouseTypes.SMALL_HOUSE:
		instance = small_house_scene.instantiate()
	
	instance.position = Vector3((position.x - 2.0) * -2.0, instance.position.y, (position.y - 2.0) * -2.0)
	self.add_child(instance)

func set_placeable_fields_visible(value: bool):
	get_node("../placeable_fields").visible = value

func _on_small_house_btn_pressed():
	if gold_amount >= 10:
		place_house = true
		place_house_type = HouseTypes.SMALL_HOUSE
		gold_to_spend = 10
		set_placeable_fields_visible(true)


func _on_big_house_btn_pressed():
	if gold_amount >= 20:
		place_house = true
		place_house_type = HouseTypes.BIG_HOUSE
		gold_to_spend = 20
		set_placeable_fields_visible(true)


func _on_skyscraper_btn_pressed():
	if gold_amount >= 50:
		place_house = true
		place_house_type = HouseTypes.SKYSCRAPER
		gold_to_spend = 50
		set_placeable_fields_visible(true)

func _on_house_set(position):
	print("positioning house on position: ", position)
	add_house(position, place_house_type)
