class_name TileMapLayerDataResource
extends NodeDataResource

@export var tilemap_layer_used_cells: Array[Vector2i]
@export var terrain_set: int = 0
@export var terrain: int = 1


func _save_data(node: Node) -> void:
	super._save_data(node)

	var layer := node as TileMapLayer
	if layer == null:
		return

	tilemap_layer_used_cells = layer.get_used_cells()

	print("Saving soil cells count: ", tilemap_layer_used_cells.size())


func _load_data(source_node: Node) -> void:
	var target = source_node.get_node_or_null(node_path)

	if target == null:
		target = source_node.get_tree().root.get_node_or_null(node_path)

	if target == null:
		push_error("TileMapLayer not found for path: " + str(node_path))
		return

	var layer := target as TileMapLayer
	if layer == null:
		return

	# 1. Clear existing cells on the layer so we start fresh from the save file
	layer.clear()

	# 2. Re-apply the tilled soil cells using terrain connection if any were saved
	if tilemap_layer_used_cells.size() > 0:
		print("Restoring ", tilemap_layer_used_cells.size(), " tilled soil cells...")
		
		layer.set_cells_terrain_connect(
			tilemap_layer_used_cells,
			terrain_set,
			terrain,
			true
		)
		print("Tilled soil successfully restored via terrain connect.")
	else:
		print("No saved tilled soil cells found.")
