class_name TileMapLayerDataResource
extends NodeDataResource

@export var saved_cells: Array[Vector2i] = []
@export var saved_source_ids: Array[int] = []
@export var saved_atlas_coords: Array[Vector2i] = []
@export var saved_alternative_tiles: Array[int] = []

func _save_data(node: Node) -> void:
	super._save_data(node)
	var layer := node as TileMapLayer
	if layer == null: return

	saved_cells.clear()
	saved_source_ids.clear()
	saved_atlas_coords.clear()
	saved_alternative_tiles.clear()

	var used = layer.get_used_cells()
	for cell in used:
		saved_cells.append(cell)
		saved_source_ids.append(layer.get_cell_source_id(cell))
		saved_atlas_coords.append(layer.get_cell_atlas_coords(cell))
		saved_alternative_tiles.append(layer.get_cell_alternative_tile(cell))
	
	print("Directly saving ", saved_cells.size(), " tiles.")

func _load_data(source_node: Node) -> void:
	var target = source_node.get_node_or_null(node_path)
	if target == null:
		target = source_node.get_tree().root.get_node_or_null(node_path)
	if target == null: return

	var layer := target as TileMapLayer
	if layer == null: return

	layer.clear()

	for i in range(saved_cells.size()):
		layer.set_cell(
			saved_cells[i],
			saved_source_ids[i],
			saved_atlas_coords[i],
			saved_alternative_tiles[i]
		)
	
	print("Directly restored ", saved_cells.size(), " tiles to TileMapLayer.")
