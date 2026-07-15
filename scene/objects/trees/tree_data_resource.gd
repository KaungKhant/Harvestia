class_name TreeDataResource
extends NodeDataResource

@export var is_chopped: bool = false


func _save_data(node: Node) -> void:
	super._save_data(node)

	var tree = node as Sprite2D

	if tree:
		is_chopped = tree.is_chopped

	print("Saving tree chopped:", is_chopped)


func _load_data(source_node: Node) -> void:

	var tree = source_node.get_node_or_null(node_path)

	if tree == null:
		print("Tree not found:", node_path)
		return

	if is_chopped:
		tree.hide()
		var collision = tree.get_node_or_null("StaticBody2D/CollisionShape2D")
		if collision:
			collision.disabled = true
			var hurt = tree.get_node_or_null("HurtComponent")
			if hurt:
				hurt.monitoring = false
				hurt.monitorable = false
	else:
		print("Restoring normal tree")
