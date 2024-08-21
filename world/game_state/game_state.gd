extends Node3D

@onready var findable_objects = $ReferenceToFindableObjects
@onready var check_list = $UI/CheckList
@onready var chronometer = $UI/Chronometer

var findables_list:Array = []

func _ready():
	PlayerTime.time = 0
	
	set_up_findable_objects()
	chronometer.activate_timer()
	check_list.checklist_setup(findables_list)
	

func set_up_findable_objects():
	for child_index in findable_objects.get_child_count():
		findables_list.append(findable_objects.get_child(child_index).name)

# The Findable Object will emit a signal before being consumed. 
func _on_findable_object_consumed(name):
	check_list.check_item(name)
	if(findables_list.size() > 0):
		findables_list.remove_at(findables_list.find(name)) 
	is_game_over()

func is_game_over():
	if (findables_list.size() == 0):
			chronometer.desactive_timer()
			PlayerTime.time = chronometer.time
			await get_tree().create_timer(4.0).timeout
			get_tree().change_scene_to_file("res://menus/game_over_screen.tscn")
