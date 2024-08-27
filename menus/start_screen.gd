extends Control

@onready var center_container: HFlowContainer = $CenterContainer
@onready var controls_creen: Control = $GuideScreen
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://world/prototype_worlds/prototype_world.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_controls_button_pressed():
	center_container.hide()
	controls_creen.show()

func _on_guide_screen_button_pressed():
	center_container.show()
	controls_creen.hide()
