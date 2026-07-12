class_name SceneDataResource
extends NodeDataResource

@export var node_name: String
@export var scene_file_path: String
@export var current_growth_stage: int
@export var is_watered: bool
@export var days_alive: int


func _save_data(node: Node) -> void:
    super._save_data(node)
    
    node_name = node.name
    scene_file_path = node.scene_file_path
    
    # Safely check if the node has these plant variables before saving
    if "current_growth_stage" in node:
        current_growth_stage = node.get("current_growth_stage")
    if "is_watered" in node:
        is_watered = node.get("is_watered")
    if "days_alive" in node:
        days_alive = node.get("days_alive")


# 🟢 FIX: Changed (window: Window) to (source_node: Node) to match parent signature
func _load_data(source_node: Node) -> void:
    var parent_node: Node
    var scene_node: Node2D

    # 🟢 Find the designated parent node relative to the scene context passed in
    if parent_node_path != null:
        parent_node = source_node.get_node_or_null(parent_node_path)
        # Fallback: Check from absolute root if the relative path failed
        if parent_node == null:
            parent_node = source_node.get_tree().root.get_node_or_null(parent_node_path)
    
    if scene_file_path != "":
        var scene_file_resource: Resource = load(scene_file_path)
        if scene_file_resource:
            scene_node = scene_file_resource.instantiate() as Node2D
        
    if parent_node != null and scene_node != null:
        # If global_position is stored in your base NodeDataResource, apply it safely
        if "global_position" in self:
            scene_node.global_position = global_position
        
        # Safely apply the saved data back to the node before adding it to the scene tree
        if "current_growth_stage" in scene_node:
            scene_node.set("current_growth_stage", current_growth_stage)
        if "is_watered" in scene_node:
            scene_node.set("is_watered", is_watered)
        if "days_alive" in scene_node:
            scene_node.set("days_alive", days_alive)
            
        parent_node.add_child(scene_node)
        
        # If your crops have a visual synchronization method, fire it here
        if scene_node.has_method("sync_loaded_state"):
            scene_node.sync_loaded_state()
    else:
        push_error("Load Error: Could not recreate scene node or find parent node at: " + str(parent_node_path))
