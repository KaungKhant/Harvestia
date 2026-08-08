extends Node

const REQUIRED := {
	"corn": 20,
	"tomato": 20,
	"carrot": 20,
	"pumpkin": 10,
	"egg": 20,
	"milk": 20,
	"log": 100,
	"stone": 100,
	"gold": 3000
}

signal donated
signal progress_updated


func get_required() -> Dictionary:
	return REQUIRED


func get_progress() -> Dictionary:
	var progress := {}

	for item in REQUIRED.keys():
		if item == "gold":
			progress[item] = PlayerProgressManager.gold
		else:
			progress[item] = InventoryManager.inventory.get(item, 0)

	return progress


func is_complete() -> bool:
	var progress := get_progress()

	for item in REQUIRED.keys():
		if progress[item] < REQUIRED[item]:
			return false

	return true


func donate_materials() -> bool:

	if !is_complete():
		return false

	# Remove inventory resources
	for item in REQUIRED.keys():

		if item == "gold":
			continue

		InventoryManager.remove_item_stack(
			item,
			REQUIRED[item]
		)

	# Remove gold
	PlayerProgressManager.spend_gold(REQUIRED["gold"])

	progress_updated.emit()
	donated.emit()

	return true


func refresh():
	progress_updated.emit()
