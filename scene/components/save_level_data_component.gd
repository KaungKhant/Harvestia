class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = ""
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource

func _ready() -> void:
    add_to_group("save_level_data_component")
    level_scene_name = get_parent().name
    save_game_data_path = ProfileManager.get_save_folder()

func save_node_data() -> void:
    var nodes = get_tree().get_nodes_in_group("save_data_component")

    print("Found ", nodes.size(), " save components")

    game_data_resource = SaveGameDataResource.new()

    for node in nodes:
        print("Saving:", node.get_parent().name)
        var data = node._save_data()

        # Safely append data without crashing if properties are missing
        if data != null:
            game_data_resource.save_data_nodes.append(data)         

func save_game() -> void:
    save_game_data_path = ProfileManager.get_save_folder()
    print("--- START SAVE ---")

    game_data_resource = SaveGameDataResource.new()

    save_node_data()
    game_data_resource.collected_items = SaveGameManager.collected_items.duplicate()

    # Save quest
    if QuestManager.current_quest != null:
        game_data_resource.current_quest_id = QuestManager.current_quest.quest_id

    game_data_resource.current_progress = QuestManager.current_progress
    game_data_resource.current_state = QuestManager.current_state
    game_data_resource.completed_quests = QuestManager.completed_quests.duplicate(true)

    # Save tools
    game_data_resource.unlocked_tools = ToolManager.unlocked_tools.duplicate()
    game_data_resource.unlocked_areas = AreaManager.unlocked_areas.duplicate()
    game_data_resource.unlocked_seeds = SeedUnlockManager.unlocked_seeds.duplicate(true)
    # Create save directory if needed
    if !DirAccess.dir_exists_absolute(save_game_data_path):
        DirAccess.make_dir_absolute(save_game_data_path)

    var level_save_file_name := save_file_name % level_scene_name
    var full_path := save_game_data_path + level_save_file_name

    var result := ResourceSaver.save(game_data_resource, full_path)

    if result == OK:
        print("Game saved successfully.")
    else:
        print("Save failed. Error:", result)

func load_game() -> void:
    save_game_data_path = ProfileManager.get_save_folder()
    var level_save_file_name := save_file_name % level_scene_name
    var save_game_path := save_game_data_path + level_save_file_name

    if !FileAccess.file_exists(save_game_path):
        print("Save file not found.")
        return

    game_data_resource = ResourceLoader.load(save_game_path)

    if game_data_resource == null:
        print("Failed to load save file.")
        return


    # =========================
    # Load Area Data
    # =========================
    AreaManager.unlocked_areas = game_data_resource.unlocked_areas.duplicate(true)

    for area_id in AreaManager.unlocked_areas.keys():
        AreaManager.area_unlocked.emit(area_id)

    print("Loaded areas:", AreaManager.unlocked_areas)
    print("Forest unlocked:", AreaManager.is_area_unlocked("forest"))


    # =========================
    # Load Quest Data
    # =========================
    QuestManager.completed_quests = game_data_resource.completed_quests.duplicate(true)
    QuestManager.restore_quest(
        game_data_resource.current_quest_id,
        game_data_resource.current_progress,
        game_data_resource.current_state
    )


    # =========================
    # Load Tool Unlocks
    ToolManager.unlocked_tools = game_data_resource.unlocked_tools.duplicate()

    for tool in ToolManager.unlocked_tools:
        ToolManager.enable_tool_button(tool)


    # ---> ADD THESE LINES TO LOAD SEED UNLOCKS <---
    if game_data_resource.unlocked_seeds != null:
        SeedUnlockManager.unlocked_seeds = game_data_resource.unlocked_seeds.duplicate(true)
        
        # Optional: Emit signals or update UI if your seed shop needs to refresh its locked visuals
        for seed_name in SeedUnlockManager.unlocked_seeds.keys():
            if SeedUnlockManager.unlocked_seeds[seed_name]:
                SeedUnlockManager.seed_unlocked.emit(seed_name)

    # =========================
    # Get Current Scene
    # =========================
    var current_scene := get_tree().current_scene

    if current_scene == null:
        current_scene = get_tree().root


    # =========================
    # Find Crop Container
    # =========================
    var crop_fields := current_scene.find_child("CropFields", true, false)


    print("Loading resources:", game_data_resource.save_data_nodes.size())


    # Remove current crops/harvests before loading
    if crop_fields:
        for child in crop_fields.get_children():
            child.queue_free()


    # =========================
    # Load Saved Objects
    # =========================
    for resource in game_data_resource.save_data_nodes:

        # -------- Crops --------
        if resource is CropDataResource:
            var crop_resource := resource as CropDataResource

            if crop_resource.scene_file_path == "":
                continue

            var crop_scene := load(crop_resource.scene_file_path)

            if crop_scene == null:
                print("Failed to load crop:", crop_resource.scene_file_path)
                continue

            var crop = crop_scene.instantiate()

            if crop_fields:
                crop_fields.add_child(crop)
            else:
                current_scene.add_child(crop)

            crop_resource._load_data(crop)

            print("Loaded crop:", crop_resource.scene_file_path)

        # -------- Harvest Items --------
        elif resource is HarvestDataResource:
            var harvest_resource := resource as HarvestDataResource

            # Skip if the item was collected/removed
            if harvest_resource.is_removed or harvest_resource.scene_file_path == "":
                continue

            var harvest_scene := load(harvest_resource.scene_file_path)

            if harvest_scene == null:
                print("Failed to load harvest:", harvest_resource.scene_file_path)
                continue

            var harvest = harvest_scene.instantiate()

            if crop_fields:
                crop_fields.add_child(harvest)
            else:
                current_scene.add_child(harvest)

            harvest_resource._load_data(harvest)

            print("Loaded harvest item successfully")
        # -------- Other Saved Nodes --------
        elif resource is NodeDataResource:
            resource._load_data(current_scene)
            
    print("===== LOAD COMPLETE =====")
