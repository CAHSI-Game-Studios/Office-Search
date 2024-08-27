extends Control

@onready var label_container : VBoxContainer = $VBoxContainer/MarginContainer/VBoxContainer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var keys: Array = PlayerTime.times.keys()
	keys.sort()
	print(keys)
	for key in keys:
		create_new_time_label(key, PlayerTime.times[key])

func _on_play_again_pressed():
		get_tree().change_scene_to_file("res://menus/StartScreen.tscn")
		PlayerTime.time = 0
		PlayerTime.times = {}

func create_new_time_label(time, text):
	var label = Label.new()
	label.text = text + ": " + str("%10.2f"%time) + "s"
	label_container.add_child(label)
