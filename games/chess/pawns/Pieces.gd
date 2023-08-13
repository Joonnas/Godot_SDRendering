extends Node3D
class_name Piece

var player := 0:
	set = set_player
var active := false
var mouse_over := false
var current_player := -1

var in_game = true

signal is_clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var material = $MeshInstance3D.mesh.material
	
	if not material or !in_game:
		return
	
	if current_player == player and mouse_over:
		if player == 0 and material.albedo_color.r != 0.8:
			material.albedo_color = Color(0.8, 0.8, 0.8, 1.0)
		elif player == 1 and material.albedo_color.r != 0.2:
			material.albedo_color = Color(0.2, 0.2, 0.2, 1.0)
	elif material.albedo_color.r != 1.0:
		if player == 0 and material.albedo_color.r != 1.0:
			material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
		elif player == 1 and material.albedo_color.r != 0.0:
			material.albedo_color = Color(0.0, 0.0, 0.0, 1.0)
	
	if active and self.position.y == 0.0:
		self.position.y = 0.2
	elif !active and self.position.y != 0.0:
		self.position.y = 0.0

func set_player(value):
	if value == 0:
		$MeshInstance3D.mesh.material = preload("res://games/chess/pawns/White_Color.tres").duplicate()
	elif value == 1:
		$MeshInstance3D.mesh.material = preload("res://games/chess/pawns/Black_Color.tres").duplicate()
	else:
		return
	$MeshInstance3D.mesh.material.resource_local_to_scene = true
	player = value


func piece_set():
	pass

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and player == current_player and in_game:
		emit_signal("is_clicked")
		active = true


func _on_area_3d_mouse_entered():
	mouse_over = true


func _on_area_3d_mouse_exited():
	mouse_over = false
