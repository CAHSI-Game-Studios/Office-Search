class_name Object_Interact
extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_value(1,false)
	set_collision_layer_value(2,true)
	
	set_collision_mask_value(2,true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
