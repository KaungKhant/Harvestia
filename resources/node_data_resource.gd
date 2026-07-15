class_name NodeDataResource
extends Resource

@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath


func _save_data(node: Node) -> void:
    node_path = node.get_path()

    if node is Node2D:
        global_position = node.global_position

    var parent := node.get_parent()
    if parent:
        parent_node_path = parent.get_path()


func _load_data(source_node: Node) -> void:
    if source_node is Node2D:
        source_node.global_position = global_position
