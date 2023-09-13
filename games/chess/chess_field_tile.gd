extends Node3D

var tile_id := Vector2i(-1, -1)
var can_state_change = false
var mouse_over := false
var occupied := -1
var current_player := -1
var c := 0:
	set = setColor

signal click

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var material = $MeshInstance3D.mesh.material
	if can_state_change and (occupied != current_player or occupied == -1) and mouse_over and material.albedo_color.r != 0.8:
		material.albedo_color = Color(0.8, 0.8, 0.8, 1.0)
	elif material.albedo_color.r != float(c):
		material.albedo_color = Color(float(c), float(c), float(c), float(c))


func setColor(value):
	if value == 1:
		$MeshInstance3D.mesh.material = preload("res://games/chess/pieces/White_Color.tres").duplicate()
	else:
		$MeshInstance3D.mesh.material = preload("res://games/chess/pieces/Black_Color.tres").duplicate()
	c = value
	#c = 1.0

func render(render_count):
	if (render_count == 3):
		$MeshInstance3D.set_layer_mask_value(20, true)
	else:
		$MeshInstance3D.set_layer_mask_value(20, false)


func _on_area_3d_mouse_entered():
	mouse_over = true


func _on_area_3d_mouse_exited():
	mouse_over = false


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and (can_state_change and (occupied != current_player or occupied == -1) and mouse_over):
		click.emit(tile_id)
