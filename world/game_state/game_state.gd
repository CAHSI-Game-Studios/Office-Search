extends Node3D

@onready var findable_objects = $ReferenceToFindableObjects
@onready var check_list = $UI/CheckList
@onready var chronometer = $UI/Chronometer

var findables_list:Array = []

func _ready():
	PlayerData.total_time = 0
	
	set_up_findable_objects()
	chronometer.activate_timer()
	check_list.checklist_setup(findables_list)

func set_up_findable_objects():
	for child_index in findable_objects.get_child_count():
		findables_list.append(findable_objects.get_child(child_index).name)

# The Findable Object will emit a signal before being consumed. 
func _on_findable_object_consumed(item_name):
	check_list.check_item(item_name)
	if(findables_list.size() > 0 and findables_list.find(item_name) != -1):
		findables_list.remove_at(findables_list.find(item_name)) 
		PlayerData.map_of_times[chronometer.time] = item_name
	is_game_over()

func is_game_over():
	if (findables_list.size() == 0):
			chronometer.game_completed()
			PlayerData.total_time = chronometer.time
			await get_tree().create_timer(4.0).timeout
			get_tree().change_scene_to_file("res://menus/GameOverScreen.tscn")

func _on_player_is_game_paused(_isPaused):
	if(_isPaused):
		chronometer.desactive_timer()
	else:
		chronometer.activate_timer()
