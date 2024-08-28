class_name  CheckList
extends Control

@onready var checklist:MenuButton = $MenuButton
@onready var item_list:ItemList = $ItemList
var items

func checklist_setup(itemList):
	for item in itemList:
		item_list.add_item(item)
	item_list.show()

func check_item(text):
	for index in item_list.item_count:
		if item_list.get_item_text(index) == text:
			item_list.remove_item(index)
			break
			
func checklist_completed():
	item_list.add_item("Checklist completed")
