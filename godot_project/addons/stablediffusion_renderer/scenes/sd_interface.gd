extends Node
class_name SD_Interface

var sd_scene: Node3D = null: set = setScene
var view = 0 # 0 = Game is in big viewport, 1 = rendered image is in big viewport

var is_sd_interface_visible = true


func _ready():
	get_window().size_changed.connect(_on_resize)


func _process(delta):
	
	$Big_Viewport_container/BigViewport/SubViewport.size = get_window().size
	
	if Input.is_action_just_pressed("sd_swap_viewports"):
		swap_viewports()

func swap_viewports():
	
	var big_viewport_content = $Big_Viewport_container/BigViewport/SubViewport.get_child(0)
	var small_viewport_content = $Small_Viewport_container/SmallViewport/SubViewport.get_child(0)
	
	$Big_Viewport_container/BigViewport/SubViewport.remove_child(big_viewport_content)
	$Small_Viewport_container/SmallViewport/SubViewport.remove_child(small_viewport_content)
	
	$Big_Viewport_container/BigViewport/SubViewport.add_child(small_viewport_content)
	$Small_Viewport_container/SmallViewport/SubViewport.add_child(big_viewport_content)
	
	view = 0 if view == 1 else 1

func _input(event):
	if event.is_action_pressed("toggle_sd_interface"):
		if view == 1:
			swap_viewports()
		get_node("Button_container").visible = !is_sd_interface_visible
		get_node("Small_Viewport_container").visible = !is_sd_interface_visible
		is_sd_interface_visible = !is_sd_interface_visible

func _on_resize():
	$Big_Viewport_container/BigViewport/SubViewport.size = get_window().size

func setScene(scene):
	var old_scene = sd_scene
	sd_scene = scene
	
	var viewport_node
	if view == 0:
		viewport_node = $Big_Viewport_container/BigViewport/SubViewport
	elif view == 1:
		viewport_node = $Small_Viewport_container/SmallViewport/SubViewport
	
	if(old_scene != null):
		viewport_node.remove_child(old_scene)
	viewport_node.add_child(scene)
	
	$Button_container/SD_Button.scene = scene
