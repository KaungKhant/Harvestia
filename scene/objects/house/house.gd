extends Node2D

@export var inside_scene: PackedScene
@onready var marker_2d: Marker2D = $EnteredArea/Marker2D

func _on_entered_area_body_entered(body: Node2D) -> void:
	body.house = self

func _on_entered_area_body_exited(body: Node2D) -> void:
	if body.house == self:
		body.house = null



func enter():
	SceneTransition.outside_spawn_position = marker_2d.global_position
	get_tree().change_scene_to_file("res://scene/objects/house/interior.tscn")
