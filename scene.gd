extends Node3D

func get_depth_texture():
	return $Depth_Texture.texture.get_image()

func get_edge_texture():
	return $Edge_Texture.texture.get_image()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Depth_Subviewport/Camera3D/MeshInstance3D.visible = true
	#$Edge_Subviewport/Edge_Cam/Edge_Mesh.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
