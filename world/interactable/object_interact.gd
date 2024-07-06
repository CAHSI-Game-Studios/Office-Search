class_name Object_Interact
extends RigidBody3D


# Set the layers once the interactable object is ready.
func _ready():
	set_collision_layer_value(1,false)
	set_collision_layer_value(2,true)
	
	set_collision_mask_value(2,true)
