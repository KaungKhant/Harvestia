extends Node

signal teach_farming
signal feed_the_animals
signal unlock_forest
signal give_axe

func action_teach_farming() -> void:
    teach_farming.emit()

func action_feed_animals() -> void:
    feed_the_animals.emit()

func action_unlock_forest() -> void:
    unlock_forest.emit()

func action_give_axe() -> void:
    give_axe.emit()
