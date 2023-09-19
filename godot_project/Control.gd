extends Control

func _on_button_pressed():
	get_node("/root/Stable_Renderer").generate_from_data(null)
