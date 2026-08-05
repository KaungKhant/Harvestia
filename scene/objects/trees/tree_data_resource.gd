class_name TreeDataResource
extends NodeDataResource

@export var is_chopped: bool = false
@export var chopped_on_day: int = -1
@export var current_damage: int = 0


func _save_data(node: Node) -> void:
	super._save_data(node)

	var tree = node as Sprite2D

	if tree:
		is_chopped = tree.is_chopped
		chopped_on_day = tree.chopped_on_day
		
		if tree.has_node("DamageComponent"):
			var damage_comp = tree.get_node("DamageComponent")
			current_damage = damage_comp.current_damage

	print("Saving tree -> Chopped:", is_chopped, "| Chopped on day:", chopped_on_day, "| Damage:", current_damage)


func _load_data(source_node: Node) -> void:
	var tree = source_node.get_node_or_null(node_path)

	if tree == null:
		print("Tree not found:", node_path)
		return

	# Restore state variables to the tree node
	tree.is_chopped = is_chopped
	tree.chopped_on_day = chopped_on_day

	# Restore damage component
	if tree.has_node("DamageComponent"):
		var damage_comp = tree.get_node("DamageComponent")
		damage_comp.current_damage = current_damage

	# Update visual and collision state based on whether it's chopped
	if is_chopped:
		tree.hide()
		tree.disable_tree_physics()
		print("Restoring tree as chopped (Chopped on day: ", chopped_on_day, ")")
	else:
		tree.show()
		if tree.has_method("enable_tree_physics"):
			tree.enable_tree_physics()
		print("Restoring normal tree")
