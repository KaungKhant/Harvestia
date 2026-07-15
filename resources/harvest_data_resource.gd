class_name HarvestDataResource
extends NodeDataResource

@export var scene_file_path: String
@export var collectable_name: String

func _save_data(node: Node) -> void:
    super._save_data(node)

    scene_file_path = node.scene_file_path

    var collectable := node.get_node_or_null("CollectableComponent")
    if collectable:
        collectable_name = collectable.collectable_name

func _load_data(node: Node) -> void:
    super._load_data(node)

    var collectable := node.get_node_or_null("CollectableComponent")
    if collectable:
        collectable.collectable_name = collectable_name
