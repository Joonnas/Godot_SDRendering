extends Node
class_name Chess_Controler

@export var field: Node3D

var current_player = 0

var in_move = false

const base_prompt = "chessfield on a table"
var variable_prompt_white = "16 white pieces"
var variable_prompt_black = "16 black pieces"

func _ready():
	self.get_parent().sd_prompt = base_prompt + ", " + variable_prompt_black + ", " + variable_prompt_white
	field.move_done.connect(finish_move)


func _process(delta):
	field.make_move(current_player)
	in_move = true

func finish_move():
	current_player = 1 if current_player == 0 else 0
	in_move = false



func render(render_count):
	field.render(render_count)
