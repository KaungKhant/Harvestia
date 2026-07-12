class_name SaveDataComponent
extends Node

# This MUST be assigned in the Inspector for the Player, Inventory, etc.
@export var save_data_resource: NodeDataResource

func _ready() -> void:
    add_to_group("save_data_component")

func _save_data() -> NodeDataResource:
    if save_data_resource == null:
        print("❌ ERROR: No resource assigned to SaveDataComponent on: ", get_parent().name)
        return null
        
    # Automatically track where this node lives relative to the level root
    save_data_resource.node_path = get_parent().get_path()
    
    # Pass the parent node (Player, Panel, etc.) into the resource to extract values
    save_data_resource._save_data(get_parent())
    
    # 🟢 CRITICAL: Return the resource so SaveLevelDataComponent can grab it!
    return save_data_resource
