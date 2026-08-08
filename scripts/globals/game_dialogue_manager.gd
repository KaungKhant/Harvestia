extends Node

signal teach_farming
signal feed_the_animals
signal unlock_forest
signal give_axe
signal give_pickaxe
signal transfer_chicken_coop
signal transfer_cow_barn
signal open_homecoming_board
signal start_homecoming_ceremony

func action_teach_farming() -> void:
	teach_farming.emit()

func action_feed_animals() -> void:
	feed_the_animals.emit()

func action_unlock_forest() -> void:
	unlock_forest.emit()

func action_give_axe() -> void:
	give_axe.emit()

func action_give_pickaxe() -> void:
	give_pickaxe.emit()

func action_transfer_chicken_coop() -> void:
	transfer_chicken_coop.emit()

func action_transfer_cow_barn() -> void:
	transfer_cow_barn.emit()
	
func action_finish_grandfather_story() -> void:
	PlayerProgressManager.talked_to_village_elder = true

func action_open_homecoming_board() -> void:
	open_homecoming_board.emit()


func action_start_homecoming_ceremony() -> void:
	start_homecoming_ceremony.emit()
