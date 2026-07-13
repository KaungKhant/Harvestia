extends Node

var collected_items: Array[String] = []

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()

func save_game() -> void:
	var save_level_data_component := get_tree().get_first_node_in_group("save_level_data_component")
	if save_level_data_component:
		save_level_data_component.save_game()

func load_game() -> void:
	var save_level_data_component := get_tree().get_first_node_in_group("save_level_data_component")
	if save_level_data_component:
		save_level_data_component.load_game()
