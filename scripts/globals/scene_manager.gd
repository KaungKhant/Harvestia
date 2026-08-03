extends Node

# Change this later if your starting scene changes.
const GAME_SCENE := "res://scene/test/test_tilemap_update_tilled_land.tscn"

func start_game():
	get_tree().change_scene_to_file(GAME_SCENE)
