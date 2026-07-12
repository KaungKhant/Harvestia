class_name ResourceNodeData
extends NodeDataResource

@export var destroyed:bool

func _save_data(node):

    super._save_data(node)

    destroyed=node.destroyed


func _load_data(window):

    var obj=window.get_node(node_path)

    obj.destroyed=destroyed

    obj.visible=!destroyed
