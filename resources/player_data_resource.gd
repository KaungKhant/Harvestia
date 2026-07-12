class_name PlayerDataResource
extends NodeDataResource

# 🟢 These are the physical properties for the Player node itself
@export var player_direction: Vector2
@export var current_tool: int 

func _save_data(node: Node) -> void:
    super._save_data(node)
    
    var player = node as CharacterBody2D
    if player != null:
        global_position = player.global_position
        player_direction = player.player_direction
        current_tool = player.current_tool


func _load_data(source_node: Node) -> void:
    var player = source_node.get_node_or_null(node_path) as CharacterBody2D
    
    if player == null:
        player = source_node.get_tree().root.get_node_or_null(node_path) as CharacterBody2D

    if player == null:
        return

    # Apply physical properties
    player.global_position = global_position
    player.player_direction = player_direction

    if ToolManager:
        ToolManager.select_tool(current_tool)
