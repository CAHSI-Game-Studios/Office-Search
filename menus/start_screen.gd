extends Control

@onready var center_container: VFlowContainer = $CenterContainer
@onready var controls_creen: Control = $GuideScreen
@onready var text_input: LineEdit = $CenterContainer/MarginContainer/LineEdit
@onready var quit_button: Button = $QuitButton
@onready var credits_button: Button = $CreditsButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_pressed():
	PlayerData.player_name = text_input.text
	print(text_input.text)
	get_tree().change_scene_to_file("res://world/prototype_worlds/prototype_world.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_controls_button_pressed():
	center_container.hide()
	quit_button.hide()
	credits_button.hide()
	controls_creen.show()

func _on_guide_screen_button_pressed():
	center_container.show()
	quit_button.show()
	credits_button.show()
	controls_creen.hide()

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://menus/credits.tscn")
