class_name CropCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

var corn_plant_scene = preload("res://scene/objects/plants/corn.tscn")
var tomato_plant_scene = preload("res://scene/objects/plants/tomato.tscn")
var carrot_plant_scene = preload("res://scene/objects/plants/carrot.tscn")
var pumpkin_plant_scene = preload("res://scene/objects/plants/pumpkin.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id : int
var local_cell_position : Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or \
		   ToolManager.selected_tool == DataTypes.Tools.PlantTomato or \
		   ToolManager.selected_tool == DataTypes.Tools.PlantCarrot or \
		   ToolManager.selected_tool == DataTypes.Tools.PlantPumpkin:
			get_cell_under_mouse()
			add_crop()

func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func add_crop() -> void:
	if distance < 20.0 and cell_source_id != -1:
		# ─── CHECK IF A CROP ALREADY EXISTS AT THIS POSITION ───
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				return # Exit early if a crop is already planted here
		
		# ─── PLANT THE SELECTED CROP ───
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			var corn_instance = corn_plant_scene.instantiate() as Node2D
			corn_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(corn_instance)
			
			InventoryManager.inventory["corn_seeds"] -= 1
			InventoryManager.inventory_changed.emit()
	
		elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			var tomato_instance = tomato_plant_scene.instantiate() as Node2D
			tomato_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(tomato_instance)
			
			InventoryManager.inventory["tomato_seeds"] -= 1
			InventoryManager.inventory_changed.emit()
			
		elif ToolManager.selected_tool == DataTypes.Tools.PlantCarrot:
			var carrot_instance = carrot_plant_scene.instantiate() as Node2D
			carrot_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(carrot_instance)
			
			InventoryManager.inventory["carrot_seeds"] -= 1
			InventoryManager.inventory_changed.emit()
			
		elif ToolManager.selected_tool == DataTypes.Tools.PlantPumpkin:
			var pumpkin_instance = pumpkin_plant_scene.instantiate() as Node2D
			pumpkin_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(pumpkin_instance)
			
			InventoryManager.inventory["pumpkin_seeds"] -= 1
			InventoryManager.inventory_changed.emit()

func remove_crop() -> void:
	if distance < 25.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
