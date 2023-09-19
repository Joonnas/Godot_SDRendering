extends Area3D
class_name Placeable_field

@export var pos : Vector2i

var is_empty := true :
	set(value):
		is_empty = value

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mouse_entered.connect(_on_mouse_enter)
	self.mouse_exited.connect(_on_mouse_exit)
	self.input_event.connect(_on_mouse_click)

func _on_mouse_enter():
	if is_empty:
		$MeshInstance3D.visible = true

func _on_mouse_exit():
	$MeshInstance3D.visible = false

func _on_mouse_click(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if is_empty:
			is_empty = false
			get_node("../../../Game_controler")._on_house_set(pos)
