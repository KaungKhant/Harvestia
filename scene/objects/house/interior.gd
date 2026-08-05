extends Node2D

var entered = false

func _on_exit_body_entered(body):
    if body.is_in_group("player"):
        get_tree().change_scene_to_file("res://scene/test/main_harvestia_update.tscn")
func _on_exit_body_exited(body: Node2D) -> void:
    if entered:
        get_tree().change_scene_to_file("res://scene/test/main_harvestia_update.tscn")
