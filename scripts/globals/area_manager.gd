extends Node

signal area_unlocked(area_id: String)

var unlocked_areas: Dictionary = {}

func _ready() -> void:
	GameDialogueManager.unlock_forest.connect(_on_unlock_forest)


func _on_unlock_forest() -> void:
	unlock_area("forest")


func unlock_area(area_id: String) -> void:
	if unlocked_areas.get(area_id, false):
		return

	unlocked_areas[area_id] = true
	area_unlocked.emit(area_id)

	NotificationManager.show_area("Forest")


func is_area_unlocked(area_id: String) -> bool:
	return unlocked_areas.get(area_id, false)
