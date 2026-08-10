extends Node2D

@export var inside_scene: PackedScene
@export var required_quest_id: String = "homecoming"

@onready var marker_2d: Marker2D = $EnteredArea/Marker2D


func _on_entered_area_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        body.house = self


func _on_entered_area_body_exited(body: Node2D) -> void:
    if body.is_in_group("player") and body.house == self:
        body.house = null


func enter():
    if not is_homecoming_completed():
        print("House is locked. Complete Homecoming quest first.")
        return

    SceneTransition.outside_spawn_position = marker_2d.global_position
    get_tree().change_scene_to_file(
		"res://scene/objects/house/interior.tscn"
    )


func is_homecoming_completed() -> bool:
    var quest_data = get_tree().get_first_node_in_group("quest_data")

    if quest_data == null:
        print("Quest data not found!")
        return false

    return quest_data.completed_quests.has(required_quest_id)
