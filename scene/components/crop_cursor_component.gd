class_name CropCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var crop_fields: Node = get_parent().find_child("CropFields")

var corn_plant_scene = preload("res://scene/objects/plants/corn.tscn")
var tomato_plant_scene = preload("res://scene/objects/plants/tomato.tscn")
var carrot_plant_scene = preload("res://scene/objects/plants/carrot.tscn")
var pumpkin_plant_scene = preload("res://scene/objects/plants/pumpkin.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("remove_dirt"):
        if ToolManager.selected_tool == DataTypes.Tools.TillGround:
            get_cell_under_mouse()
            remove_crop()

    elif event.is_action_pressed("hit"):
        if ToolManager.selected_tool == DataTypes.Tools.PlantCorn \
        or ToolManager.selected_tool == DataTypes.Tools.PlantTomato \
        or ToolManager.selected_tool == DataTypes.Tools.PlantCarrot \
        or ToolManager.selected_tool == DataTypes.Tools.PlantPumpkin:
            get_cell_under_mouse()
            add_crop()


func get_cell_under_mouse() -> void:
    mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
    cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
    cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
    local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
    distance = player.global_position.distance_to(local_cell_position)


func add_crop() -> void:
    if distance >= 20.0:
        return

    if cell_source_id == -1:
        return

    # Check if a crop already exists on this tile
    for node in crop_fields.get_children():

        if !is_instance_valid(node):
            continue

        if node.is_queued_for_deletion():
            continue

        # Ignore dropped harvest items
        if node is CornHarvest:
            continue

        var node_cell = tilled_soil_tilemap_layer.local_to_map(node.global_position)

        if node_cell == cell_position:
            return


    match ToolManager.selected_tool:

        DataTypes.Tools.PlantCorn:
            if InventoryManager.inventory["corn_seeds"] <= 0:
                return

            var crop = corn_plant_scene.instantiate()
            crop.global_position = local_cell_position
            crop_fields.add_child(crop)

            InventoryManager.inventory["corn_seeds"] -= 1


        DataTypes.Tools.PlantTomato:
            if InventoryManager.inventory["tomato_seeds"] <= 0:
                return

            var crop = tomato_plant_scene.instantiate()
            crop.global_position = local_cell_position
            crop_fields.add_child(crop)

            InventoryManager.inventory["tomato_seeds"] -= 1


        DataTypes.Tools.PlantCarrot:
            if InventoryManager.inventory["carrot_seeds"] <= 0:
                return

            var crop = carrot_plant_scene.instantiate()
            crop.global_position = local_cell_position
            crop_fields.add_child(crop)

            InventoryManager.inventory["carrot_seeds"] -= 1


        DataTypes.Tools.PlantPumpkin:
            if InventoryManager.inventory["pumpkin_seeds"] <= 0:
                return

            var crop = pumpkin_plant_scene.instantiate()
            crop.global_position = local_cell_position
            crop_fields.add_child(crop)

            InventoryManager.inventory["pumpkin_seeds"] -= 1


    InventoryManager.inventory_changed.emit()


func remove_crop() -> void:
    if distance >= 25.0:
        return

    for node in crop_fields.get_children():

        if !is_instance_valid(node):
            continue

        if node.is_queued_for_deletion():
            continue

        if node is CornHarvest:
            continue

        var node_cell = tilled_soil_tilemap_layer.local_to_map(node.global_position)

        if node_cell == cell_position:
            node.queue_free()
            return
