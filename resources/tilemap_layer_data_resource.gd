class_name TileMapLayerDataResource
extends NodeDataResource

@export var tilemap_layer_used_cells: Array[Vector2i]
@export var terrain_set: int = 0
@export var terrain: int = 1


func _save_data(node: Node) -> void:
    super._save_data(node)

    var layer := node as TileMapLayer

    tilemap_layer_used_cells = layer.get_used_cells()

    print("Saving soil cells:", tilemap_layer_used_cells.size())

    for cell in tilemap_layer_used_cells:
        print(
            cell,
            " source=", layer.get_cell_source_id(cell),
            " atlas=", layer.get_cell_atlas_coords(cell),
            " alt=", layer.get_cell_alternative_tile(cell)
        )


func _load_data(source_node: Node) -> void:
    var target = source_node.get_node_or_null(node_path)

    if target == null:
        target = source_node.get_tree().root.get_node_or_null(node_path)

    if target == null:
        push_error("TileMapLayer not found.")
        return

    var layer := target as TileMapLayer

    if tilemap_layer_used_cells.size() > 0:
        print("Terrain Set:", terrain_set)
        print("Terrain:", terrain)

        layer.set_cells_terrain_connect(
            tilemap_layer_used_cells,
            terrain_set,
            terrain,
            true
        )

    print("Loaded soil cells:", tilemap_layer_used_cells.size())
