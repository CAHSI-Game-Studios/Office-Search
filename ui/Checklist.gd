class_name  CheckList
extends Control

@onready var checklist:MenuButton = $MenuButton
@onready var item_list:ItemList = $ItemList
var items

func _process(_delta):
	if Input.is_action_just_pressed("checklist_toggle"):
		toggle_list()

func toggle_list():
	if not item_list.visible:
		item_list.show()
	else:
		item_list.hide()

func checklist_setup(itemList):
	for item in itemList:
		item_list.add_item(item)
	item_list.show()

func check_item(text):
	for index in item_list.item_count:
		if item_list.get_item_text(index) == text:
			item_list.remove_item(index)
			break
