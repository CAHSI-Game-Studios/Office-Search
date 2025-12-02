extends Control

@onready var label : Label = $VBoxContainer/MarginContainer/Label

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	label.text = "Total: " + str("%10.2f"%PlayerData.total_time) + "s"
	
	
	var keys: Array = PlayerData.map_of_times.keys()
	keys.sort()
	
	# Create data directory
	DirAccess.make_dir_recursive_absolute("user://data")
	var current_time = Time.get_time_string_from_system()
	current_time = current_time.replace(":","-")
	var file_name = "user://data/" + PlayerData.player_name +"_"+ Time.get_date_string_from_system() + "_" + current_time
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_line("Player's Code: " + PlayerData.player_name)
	file.store_line("Object's Name  | Object's Time Since Start    | Object's Time Since Last Object Found")
	for i in range(len(keys)):
		file.store_line(str(i + 1) + ") " + create_new_time_label(keys[i], PlayerData.map_of_times[keys[i]]) + "                 |" + get_time_diff(keys, i))
	file.close()
	
func _on_play_again_pressed():
		get_tree().change_scene_to_file("res://menus/StartScreen.tscn")
		PlayerData.total_time = 0
		PlayerData.map_of_times = {}

func create_new_time_label(time, text):
	var spaces_to_add = " ".repeat(12 - len(text))
	var full_text = (text + spaces_to_add + "|" + str("%12.3f"%time) + "s")
	return full_text
	
func get_time_diff(keys, i):
	
	if(i == 0):
		return str("%12.3f"%keys[i]) + "s"
	else:
		return  str("%12.3f"%(abs(keys[i-1] - keys[i]))) + "s"
