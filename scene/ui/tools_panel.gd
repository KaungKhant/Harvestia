extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering: Button = $MarginContainer/HBoxContainer/ToolWatering
@onready var corn: Button = $MarginContainer/HBoxContainer/Corn
@onready var tomato: Button = $MarginContainer/HBoxContainer/Tomato
@onready var tool_pickaxe: Button = $MarginContainer/HBoxContainer/ToolPickaxe
@onready var tool_scythe: Button = $MarginContainer/HBoxContainer/ToolScythe

# ─── NEW: Reference your visual quantity labels here ───
@onready var corn_label: Label = $MarginContainer/HBoxContainer/Corn/CornLabel
@onready var tomato_label: Label = $MarginContainer/HBoxContainer/Tomato/TomatoLabel

# List of all UI slot buttons to reset their brightness
var all_buttons: Array = []

func _ready() -> void:
	ToolManager.enable_tool.connect(on_enable_tool_button)
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	
	# Initial lock states for progression tools
	tool_tilling.disabled = true
	tool_tilling.focus_mode = Control.FOCUS_NONE
	tool_watering.disabled = true
	tool_watering.focus_mode = Control.FOCUS_NONE
	tool_pickaxe.disabled = true
	tool_pickaxe.focus_mode = Control.FOCUS_NONE
	tool_scythe.disabled = true
	tool_scythe.focus_mode = Control.FOCUS_NONE
	
	# Seed buttons start locked until bought from the shop
	corn.disabled = true
	corn.focus_mode = Control.FOCUS_NONE
	tomato.disabled = true
	tomato.focus_mode = Control.FOCUS_NONE
	
	# Connect button click listeners
	tool_axe.pressed.connect(_on_axe_pressed)
	tool_tilling.pressed.connect(_on_tilling_pressed)
	tool_watering.pressed.connect(_on_watering_pressed)
	tool_pickaxe.pressed.connect(_on_tool_pickaxe_pressed)
	tool_scythe.pressed.connect(_on_tool_scythe_pressed)
	corn.pressed.connect(_on_corn_pressed)
	tomato.pressed.connect(_on_tomato_pressed)
	
	all_buttons = [tool_axe, tool_scythe, tool_pickaxe, tool_tilling, tool_watering, corn, tomato]
	
	ToolManager.tool_selected.connect(_on_global_tool_selected)
	_on_global_tool_selected(ToolManager.selected_tool)
	
	# Run once on startup to sync data
	on_inventory_changed()


# ─── REFRESH SEED QUANTITIES & LOCKS ───
func on_inventory_changed() -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	# --- CORN SEEDS ---
	var corn_count = inventory.get("corn_seeds", 0)
	# Update the label's text visually, keeping the button's image clean!
	corn_label.text = str(corn_count)
	
	if corn_count > 0:
		corn.disabled = false
		corn.focus_mode = Control.FOCUS_ALL
	else:
		corn.disabled = true
		corn.focus_mode = Control.FOCUS_NONE
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			ToolManager.select_tool(DataTypes.Tools.None)

	# --- TOMATO SEEDS ---
	var tomato_count = inventory.get("tomato_seeds", 0)
	# Update the label's text visually
	tomato_label.text = str(tomato_count)
	
	if tomato_count > 0:
		tomato.disabled = false
		tomato.focus_mode = Control.FOCUS_ALL
	else:
		tomato.disabled = true
		tomato.focus_mode = Control.FOCUS_NONE
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			ToolManager.select_tool(DataTypes.Tools.None)


# ─── VISUAL HIGHLIGHTS ───
func _on_global_tool_selected(active_tool: DataTypes.Tools) -> void:
	for btn in all_buttons:
		if btn:
			btn.modulate = Color(0.6, 0.6, 0.6, 1.0)
	
	match active_tool:
		DataTypes.Tools.AxeWood: tool_axe.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.Scythe: tool_scythe.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.Pickaxe: tool_pickaxe.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.TillGround: tool_tilling.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.WaterCrops: tool_watering.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.PlantCorn: corn.modulate = Color(1.5, 1.5, 1.5, 1.0)
		DataTypes.Tools.PlantTomato: tomato.modulate = Color(1.5, 1.5, 1.5, 1.0)

# ─── MOUSE CLICK SELECTION ───
func _on_axe_pressed() -> void: ToolManager.select_tool(DataTypes.Tools.AxeWood)
func _on_tool_scythe_pressed() -> void: ToolManager.select_tool(DataTypes.Tools.Scythe)
func _on_tool_pickaxe_pressed() -> void: ToolManager.select_tool(DataTypes.Tools.Pickaxe)
func _on_tilling_pressed() -> void: ToolManager.select_tool(DataTypes.Tools.TillGround)
func _on_watering_pressed() -> void: ToolManager.select_tool(DataTypes.Tools.WaterCrops)
func _on_corn_pressed() -> void: ToolManager.select_tool(DataTypes.Tools.PlantCorn)
func _on_tomato_pressed() -> void: ToolManager.select_tool(DataTypes.Tools.PlantTomato)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		ToolManager.select_tool(DataTypes.Tools.None)
		for btn in all_buttons:
			if btn: btn.release_focus()

func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	if tool == DataTypes.Tools.TillGround:
		tool_tilling.disabled = false
		tool_tilling.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.Scythe:
		tool_scythe.disabled = false
		tool_scythe.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.Pickaxe:
		tool_pickaxe.disabled = false
		tool_pickaxe.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.WaterCrops:
		tool_watering.disabled = false
		tool_watering.focus_mode = Control.FOCUS_ALL
