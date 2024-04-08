extends ColorRect

@onready var start: Button = find_child("Start Game")
@onready var quit: Button = find_child("Quit")
@export var Start_Level: PackedScene



func _ready():
	quit.pressed.connect(get_tree().quit)

func _on_start_game_pressed():
	get_tree().change_scene_to_packed(Start_Level)

	
