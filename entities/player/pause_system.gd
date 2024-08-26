extends Control

@onready var _pause_control = $PauseControl
@onready var _isPause: bool = false

func _input(event):
	if event.is_action_pressed("pause"):
		if _isPause:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			_pause_control.hide()
			_isPause = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			_pause_control.show()
			_isPause = true

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://menus/StartScreen.tscn")

func _on_continue_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_pause_control.hide()
	_isPause = false
