extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape3D.make_convex_from_siblings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
