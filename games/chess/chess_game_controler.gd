extends Node
class_name Chess_Controler

@export var field: Node3D

var current_player = 0

var in_move = false

func _ready():
	field.move_done.connect(finish_move)


func _process(delta):
	field.make_move(current_player)
	in_move = true

func finish_move():
	current_player = 1 if current_player == 0 else 0
	in_move = false
