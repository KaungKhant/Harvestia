extends PanelContainer
@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var corn_label: Label = $MarginContainer/VBoxContainer/Corn/CornLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomato/TomatoLabel
@onready var egg_label: Label = $MarginContainer/VBoxContainer/Egg/EggLabel
@onready var milk_label: Label = $MarginContainer/VBoxContainer/Milk/MilkLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)

	on_inventory_changed()

func on_inventory_changed() -> void:
	var inventory: Dictionary = InventoryManager.inventory

	log_label.text = str(inventory.get("log", 0))
	stone_label.text = str(inventory.get("stone", 0))
	corn_label.text = str(inventory.get("corn", 0))
	tomato_label.text = str(inventory.get("tomato", 0))
	egg_label.text = str(inventory.get("egg", 0))
	milk_label.text = str(inventory.get("milk", 0))
