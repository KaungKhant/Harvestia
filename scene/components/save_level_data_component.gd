class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource

func _ready() -> void:
    add_to_group("save_level_data_component")
    level_scene_name = get_parent().name

func save_node_data() -> void:
    var nodes = get_tree().get_nodes_in_group("save_data_component")
    print("--- STARTING SAVE_NODE_DATA ---")
    print("Found ", nodes.size(), " nodes in group 'save_data_component'")
    
    game_data_resource = SaveGameDataResource.new()
    
    if nodes != null:
        for node in nodes:
            # Changed from 'if node is SaveDataComponent:' to checking if it has the function
            if node.has_method("_save_data"):
                print("Processing node: ", node.get_parent().name)
                var save_data_resource: NodeDataResource = node._save_data()
                
                if save_data_resource == null:
                    print("❌ WARNING: Node '", node.get_parent().name, "' returned NULL data resource.")
                    continue
                
                var save_final_resource = save_data_resource.duplicate()
                game_data_resource.save_data_nodes.append(save_final_resource)
                print("✅ Successfully appended data for: ", node.get_parent().name)
                
func save_game() -> void:
    print("--- STARTING SAVE_GAME ---")
    if !DirAccess.dir_exists_absolute(save_game_data_path):
        print("Directory does not exist. Creating directory: ", save_game_data_path)
        DirAccess.make_dir_absolute(save_game_data_path)
        
    var level_save_file_name: String = save_file_name % level_scene_name
    var full_path: String = save_game_data_path + level_save_file_name
    print("Target save path: ", full_path)
    
    save_node_data()
    
    if game_data_resource.save_data_nodes.size() == 0:
        print("❌ ABORTING SAVE: No node data was collected!")
        return
        
    var result: int = ResourceSaver.save(game_data_resource, full_path)
    
    if result == OK:
        print("🎉 SUCCESS! Game saved successfully. Code:", result)
    else:
        print("❌ CRITICAL ERROR: ResourceSaver failed to write file. Error code:", result)
    print("--- ENDING SAVE_GAME ---")

func load_game() -> void:
    var level_save_file_name := save_file_name % level_scene_name
    var save_game_path := save_game_data_path + level_save_file_name

    if !FileAccess.file_exists(save_game_path):
        print("Save file not found.")
        return

    game_data_resource = ResourceLoader.load(save_game_path)

    if game_data_resource == null:
        print("Failed to load save file.")
        return

    var current_scene := get_tree().current_scene
    if current_scene == null:
        current_scene = get_tree().root

    # Find CropFields
    var crop_fields := current_scene.find_child("CropFields", true, false)

    print("Loading ", game_data_resource.save_data_nodes.size(), " resources...")
    if crop_fields:
        for child in crop_fields.get_children():
            child.queue_free()

    for resource in game_data_resource.save_data_nodes:

        # -------- Dynamic Crops --------
        if resource is CropDataResource:

            var crop_resource := resource as CropDataResource

            if crop_resource.scene_file_path == "":
                continue

            var crop_scene := load(crop_resource.scene_file_path)

            if crop_scene == null:
                print("Failed to load: ", crop_resource.scene_file_path)
                continue

            var crop = crop_scene.instantiate()

            if crop_fields:
                crop_fields.add_child(crop)
            else:
                current_scene.add_child(crop)

            crop_resource._load_data(crop)

            print("Loaded crop:", crop_resource.scene_file_path)

        # -------- Static objects --------
        elif resource is NodeDataResource:

            resource._load_data(current_scene)
