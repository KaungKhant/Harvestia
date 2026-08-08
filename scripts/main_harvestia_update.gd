extends Node2D

func _ready():
	var player = get_tree().get_first_node_in_group("player")

	if SceneTransition.outside_spawn_position != Vector2.ZERO:
		player.global_position = SceneTransition.outside_spawn_position
		SceneTransition.outside_spawn_position = Vector2.ZERO
