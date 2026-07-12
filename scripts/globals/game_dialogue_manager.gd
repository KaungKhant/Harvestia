extends Node

signal teach_farming
signal feed_the_animals

func action_teach_farming() -> void:
	teach_farming.emit()

func action_feed_animals() -> void:
	feed_the_animals.emit()
signal unlock_forest

func action_unlock_forest():
	unlock_forest.emit()
