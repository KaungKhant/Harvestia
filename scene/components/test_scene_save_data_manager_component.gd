class_name TestSceneSaveDataManagerComponent
extends Node

func _ready() -> void:
    await get_tree().process_frame

    if SceneTransition.returning_from_house:
        SceneTransition.returning_from_house = false
        print("Returning from house - reloading scene data only.")

        var save_level_data_component := get_tree().get_first_node_in_group("save_level_data_component")

        if save_level_data_component and save_level_data_component._read_save_file():
            save_level_data_component._load_scene_data()
        else:
            print("No save file to reload scene data from.")

        return

    if ProfileSaveManager.current_profile_has_save():
        print("Loading save for:", ProfileManager.get_profile())
        SaveGameManager.load_game()  # full load: progress + scene data
    else:
        print("New profile - starting fresh.")

func load_test_scene():
    if ProfileSaveManager.current_profile_has_save():
        SaveGameManager.load_game()
