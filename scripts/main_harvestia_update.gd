extends Node2D

func _ready() -> void:
    print("================================")
    print("MAIN WORLD READY")
    print("================================")

    await get_tree().process_frame

    var player := get_tree().get_first_node_in_group("player")
    if player == null:
        print("ERROR: Player not found.")
        return

    if SceneTransition.outside_spawn_position != Vector2.ZERO:
        print(
            "Restoring player position: ",
            SceneTransition.outside_spawn_position
        )
        player.global_position = (
            SceneTransition.outside_spawn_position
        )
        SceneTransition.outside_spawn_position = Vector2.ZERO

    print("Player position: ", player.global_position)

    # Re-apply house restoration if homecoming is already complete.
    print("Homecoming completed? ", QuestManager.is_quest_completed("homecoming"))

    if QuestManager.is_quest_completed("homecoming"):
        _apply_house_restoration()


func _apply_house_restoration() -> void:
    var damaged_house := find_child("QuestHome", true, false)
    var repaired_house := find_child("QuestHomeRepaired", true, false)
    var house := find_child("House", true, false)

    if damaged_house == null:
        print("ERROR: QuestHome NOT FOUND during restoration re-apply.")
    else:
        damaged_house.hide()

    if repaired_house == null:
        print("ERROR: QuestHomeRepaired NOT FOUND during restoration re-apply.")
    else:
        repaired_house.hide()

    if house == null:
        print("ERROR: House NOT FOUND during restoration re-apply.")
    else:
        house.show()

    print("House restoration re-applied on load.")
