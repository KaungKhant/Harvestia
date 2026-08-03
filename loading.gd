extends Control

const GAME_SCENE := "res://scene/test/main_harvestia_update.tscn"

func _ready() -> void:
	# Let Godot draw the loading screen first
	await get_tree().process_frame

	# Show loading screen for 0.5 seconds
	await get_tree().create_timer(0.5).timeout

	# Go to the game world
	get_tree().change_scene_to_file(GAME_SCENE)
