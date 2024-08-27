extends Control

signal is_game_paused(_isPaused)

@onready var _pause_control = $PauseControl
@onready var _isPaused: bool = false

func _input(event):
	if event.is_action_pressed("pause"):
		if _isPaused:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			_pause_control.hide()
			_isPaused = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			_pause_control.show()
			_isPaused = true
		is_game_paused.emit(_isPaused)

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://menus/StartScreen.tscn")

func _on_continue_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_pause_control.hide()
	_isPaused = false
	is_game_paused.emit(_isPaused)
