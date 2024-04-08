extends ColorRect

@onready var resume: Button = find_child("Resume")
@onready var quit: Button = find_child("Quit")

var pause: bool = false;

func _unhandled_input(event: InputEvent):
	if (event.is_action_pressed("pause")):
		PauseMenu()

func _ready():
	set_visible(pause)
	resume.pressed.connect(PauseMenu)
	quit.pressed.connect(get_tree().quit)

func PauseMenu():
	pause = !pause
	if pause:
		set_visible(true)
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		set_visible(false)
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)




