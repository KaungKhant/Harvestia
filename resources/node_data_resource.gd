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

# Inside tilemap_layer_data_resource.gd (and node_data_resource.gd)

# Change (window: Window) to (source_node: Node)
func _load_data(source_node: Node) -> void:
    pass
        
    # ... rest of your loading logic stays the same ...
