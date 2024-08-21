extends Control

@onready var time_finished : Label = $VBoxContainer/MarginContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	time_finished.text = "TIME: " + str(PlayerTime.time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_again_pressed():
		get_tree().change_scene_to_file("res://menus/StartScreen.tscn")
