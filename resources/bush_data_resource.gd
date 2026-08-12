class_name BushDataResource
extends NodeDataResource

@export var is_chopped: bool = false
@export var chopped_on_day: int = -1
@export var current_damage: int = 0


func _save_data(node: Node) -> void:
	super._save_data(node)

	var bush = node as Sprite2D

	if bush:
		is_chopped = bush.is_chopped
		chopped_on_day = bush.chopped_on_day
		
		if bush.has_node("DamageComponent"):
			var damage_comp = bush.get_node("DamageComponent")
			current_damage = damage_comp.current_damage

	print("Saving bush -> Destroyed:", is_chopped, "| Destroyed on day:", chopped_on_day, "| Damage:", current_damage)


func _load_data(source_node: Node) -> void:
	var bush = source_node.get_node_or_null(node_path)

	if bush == null:
		print("Bush not found:", node_path)
		return

	# Restore state variables to the bush node
	bush.is_chopped = is_chopped
	bush.chopped_on_day = chopped_on_day

	# Restore damage component
	if bush.has_node("DamageComponent"):
		var damage_comp = bush.get_node("DamageComponent")
		damage_comp.current_damage = current_damage

	# Update visual and collision state based on whether it's destroyed
	if is_chopped:
		bush.hide()
		if bush.has_method("disable_bush_physics"):
			bush.disable_bush_physics()
		print("Restoring bush as destroyed (Destroyed on day: ", chopped_on_day, ")")
	else:
		bush.show()
		if bush.has_method("enable_bush_physics"):
			bush.enable_bush_physics()
		print("Restoring normal bush")
