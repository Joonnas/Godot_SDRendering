extends Node

@onready var main_menu_instance = $Main_Menu

var sd_interface_instance = preload("res://addons/stablediffusion_renderer/scenes/sd_interface.tscn").instantiate()

enum GameStates {IN_MENU, IN_GAME}
var current_gamestate: GameStates = GameStates.IN_MENU: set = set_gamestate

func _ready():
	pass


func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("to_main_menu"):
		current_gamestate = GameStates.IN_MENU
	elif event.is_action_pressed("exit_game"):
		get_tree().quit()

func set_gamestate(state):
	if state == GameStates.IN_GAME:
		self.remove_child(main_menu_instance)
		self.add_child(sd_interface_instance)
	elif state == GameStates.IN_MENU:
		self.remove_child(sd_interface_instance)
		self.add_child(main_menu_instance)
	current_gamestate = state


func _on_depth_game_btn_pressed():
	print("DEPTH Game")
	sd_interface_instance.sd_scene = load("res://games/citybuild/citybuild.tscn").instantiate()
	set_gamestate(GameStates.IN_GAME)


func _on_edge_game_btn_pressed():
	print("EDGE Game")
