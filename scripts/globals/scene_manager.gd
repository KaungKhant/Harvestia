extends Node

const LOADING_SCENE := "res://loading.tscn"

func start_game():
	get_tree().change_scene_to_file(LOADING_SCENE)
