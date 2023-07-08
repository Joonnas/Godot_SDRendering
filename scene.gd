extends Node3D

func get_depth_texture():
	return $TextureRect.texture.get_image()

# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewport/Camera3D/MeshInstance3D.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
