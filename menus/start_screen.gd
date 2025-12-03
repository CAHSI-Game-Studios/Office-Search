extends Control

@onready var center_container: VFlowContainer = $CenterContainer
@onready var controls_creen: Control = $GuideScreen
@onready var text_input: LineEdit = $CenterContainer/MarginContainer/LineEdit
@onready var quit_button: Button = $QuitButton
@onready var credits_button: Button = $CreditsButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Joypads connected: ", Input.get_connected_joypads())

	# Make interactive controls focusable
	text_input.focus_mode = Control.FOCUS_ALL
	quit_button.focus_mode = Control.FOCUS_ALL
	credits_button.focus_mode = Control.FOCUS_ALL
	controls_creen.focus_mode = Control.FOCUS_ALL  # container/panel
	# start focus
	text_input.grab_focus()

	# down from TextInput goes to Credits (not Quit)
	text_input.focus_neighbor_bottom = credits_button.get_path()
	# up from TextInput wraps to Quit (optional, for a loop)
	text_input.focus_neighbor_top = quit_button.get_path()

	# Credits sits between TextInput and Quit
	credits_button.focus_neighbor_top = text_input.get_path()
	credits_button.focus_neighbor_bottom = quit_button.get_path()

	# Quit is the bottom; up goes back to Credits
	quit_button.focus_neighbor_top = credits_button.get_path()
	# optional: down from Quit wraps back to TextInput
	quit_button.focus_neighbor_bottom = text_input.get_path()


	 
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
