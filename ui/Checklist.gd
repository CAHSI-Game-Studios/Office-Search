extends Control

var checklist
var items
var toggled

# Called when the node enters the scene tree for the first time.
func _ready():
	items = ["item1", "item2", "item3"]
	checklist = get_node("MenuButton")
	checklist_setup(items)
	toggled = checklist.is_pressed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check item called in process
	if Input.is_action_just_pressed("checklist_toggle"):
		toggled = !toggled
	checklist.set_pressed_no_signal(toggled)
	if(checklist.is_pressed()):
		checklist.show_popup()
	else:
		checklist.get_popup().hide()


func checklist_setup(itemList):
	var index = 0
	for item in itemList:
		checklist.get_popup().add_check_item(item, index)
		checklist.get_popup().set_item_disabled(index, true)
		index+=1

func check_item(itemIndex):
	checklist.get_popup().set_item_checked(itemIndex, true)
