class_name Drawer
extends Node3D

@export var animation : AnimationPlayer

var drawer_state = true

func drawer_interaction():
	
	if Input.is_action_just_pressed("l_click") and !animation.is_playing():
		if drawer_state:
			animation.play("Open") 
		else:
			animation.play("Close") 
		drawer_state = !drawer_state
