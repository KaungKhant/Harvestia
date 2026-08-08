class_name TestSceneSaveDataManagerComponent
extends Node

func _ready() -> void:

    await get_tree().process_frame

    if ProfileSaveManager.current_profile_has_save():

        print("Loading save for:", ProfileManager.get_profile())

        SaveGameManager.load_game()

    else:

        print("New profile - starting fresh.")


func load_test_scene():

    if ProfileSaveManager.current_profile_has_save():

        SaveGameManager.load_game()
