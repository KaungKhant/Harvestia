extends Node2D

@export var inside_scene: PackedScene

func _on_entered_area_body_entered(body: Node2D) -> void:
    body.house = self

func _on_entered_area_body_exited(body: Node2D) -> void:
    if body.house == self:
        body.house = null

func enter():
    get_tree().change_scene_to_file("res://scene/objects/house/interior.tscn")
