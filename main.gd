extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().size_changed.connect(_on_resize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_resize():
	$Big_Viewport_container/BigViewport/SubViewport.size = get_window().size
