extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://world/prototype_worlds/prototype_world.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
