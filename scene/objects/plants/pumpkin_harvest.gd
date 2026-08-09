extends Area2D
class_name PumpkinHarvest

@export_file("*.tscn")
var harvest_scene_path := "res://scene/objects/plants/pumpkin_harvest.tscn"

@export var item_name:String = "pumpkin"

func _ready():
 add_to_group("harvest_items")
func get_item_name() -> String:
 return item_name


func set_item_name(value: String) -> void:
 item_name = value

func _on_body_entered(body: Node2D) -> void:
 if body is Player:
  InventoryManager.add_collectable(item_name)
  QuestManager.add_progress(item_name)
  queue_free()
