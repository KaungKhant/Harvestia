class_name HarvestDataResource
extends NodeDataResource

@export var scene_file_path: String
@export var collectable_name: String
@export var is_removed: bool = false

func _save_data(node: Node) -> void:
    super._save_data(node)

    if node is CornHarvest: # (or your general harvest node base class)
        scene_file_path = node.scene_file_path
        collectable_name = node.item_name
        
    is_removed = false

func _load_data(node: Node) -> void:
    super._load_data(node)

    if node is CornHarvest:
        node.item_name = collectable_name
