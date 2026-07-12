extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering: Button = $MarginContainer/HBoxContainer/ToolWatering
@onready var corn: Button = $MarginContainer/HBoxContainer/Corn
@onready var tomato: Button = $MarginContainer/HBoxContainer/Tomato
@onready var tool_pickaxe: Button = $MarginContainer/HBoxContainer/ToolPickaxe
@onready var tool_scythe: Button = $MarginContainer/HBoxContainer/ToolScythe



# List of all UI slot buttons to reset their brightness
var all_buttons: Array = []

func _ready() -> void:
    ToolManager.enable_tool.connect(on_enable_tool_button)
    
    tool_tilling.disabled = true
    tool_tilling.focus_mode = Control.FOCUS_NONE
    
    tool_watering.disabled = true
    tool_watering.focus_mode = Control.FOCUS_NONE
    
    tool_pickaxe.disabled = true
    tool_pickaxe.focus_mode = Control.FOCUS_NONE
    
    tool_scythe.disabled = true
    tool_scythe.focus_mode = Control.FOCUS_NONE
    
    corn.disabled = true
    corn.focus_mode = Control.FOCUS_NONE
    
    tomato.disabled = true
    tomato.focus_mode = Control.FOCUS_NONE
    # 1. Connect all buttons to their click functions programmatically
    tool_axe.pressed.connect(_on_axe_pressed)
    tool_tilling.pressed.connect(_on_tilling_pressed)
    tool_watering.pressed.connect(_on_watering_pressed)
    tool_pickaxe.pressed.connect(_on_tool_pickaxe_pressed)
    tool_scythe.pressed.connect(_on_tool_scythe_pressed)
    corn.pressed.connect(_on_corn_pressed)
    tomato.pressed.connect(_on_tomato_pressed)
    
    # 2. Put all buttons into an array so we can dim them down cleanly
    all_buttons = [tool_axe,tool_scythe,tool_pickaxe, tool_tilling, tool_watering, corn, tomato]
    
    # 3. Listen to the global ToolManager signal for hotkey presses (O/P)
    ToolManager.tool_selected.connect(_on_global_tool_selected)
    
    # Run once on startup to set up the default visual state
    _on_global_tool_selected(ToolManager.selected_tool)


# ─── THE VISUAL HIGHLIGHT FIX ───
func _on_global_tool_selected(active_tool: DataTypes.Tools) -> void:
    # Step A: Dim ALL buttons in the slot row by default (including seeds!)
    for btn in all_buttons:
        if btn:
            btn.modulate = Color(0.6, 0.6, 0.6, 1.0) # Clean, uniform grayish tint
    
    # Step B: Brighten ONLY the button matching our active tool selection
    match active_tool:
        DataTypes.Tools.AxeWood:
            tool_axe.modulate = Color(1.5, 1.5, 1.5, 1.0)
        DataTypes.Tools.Scythe:
            tool_scythe.modulate = Color(1.5, 1.5, 1.5, 1.0)
        DataTypes.Tools.Pickaxe:
            tool_pickaxe.modulate = Color(1.5, 1.5, 1.5, 1.0)
        DataTypes.Tools.TillGround:
            tool_tilling.modulate = Color(1.5, 1.5, 1.5, 1.0)
        DataTypes.Tools.WaterCrops:
            tool_watering.modulate = Color(1.5, 1.5, 1.5, 1.0)
        DataTypes.Tools.PlantCorn:
            corn.modulate = Color(1.5, 1.5, 1.5, 1.0)
        DataTypes.Tools.PlantTomato:
            tomato.modulate = Color(1.5, 1.5, 1.5, 1.0)
        # 💡 (Optional) If you add seed states to your tool enum later, add them here!
        # DataTypes.Tools.PlantCorn:
        #     corn.modulate = Color(1.5, 1.5, 1.5, 1.0)


# ─── MOUSE CLICK SELECTION ───
func _on_axe_pressed() -> void:
    ToolManager.select_tool(DataTypes.Tools.AxeWood)

func _on_tool_scythe_pressed() -> void:
    ToolManager.select_tool(DataTypes.Tools.Scythe) # Replace with function body.

func _on_tool_pickaxe_pressed() -> void:
    ToolManager.select_tool(DataTypes.Tools.Pickaxe) # Replace with function body.

func _on_tilling_pressed() -> void:
    ToolManager.select_tool(DataTypes.Tools.TillGround)
    
func _on_watering_pressed() -> void:
    ToolManager.select_tool(DataTypes.Tools.WaterCrops)

func _on_corn_pressed() -> void:
    ToolManager.select_tool(DataTypes.Tools.PlantCorn)
    # If you want corn clicks to do something, assign its tool type here later!

func _on_tomato_pressed() -> void:
    ToolManager.select_tool(DataTypes.Tools.PlantTomato)
    # If you want tomato clicks to do something, assign its tool type here later!
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            ToolManager.select_tool(DataTypes.Tools.None)
            tool_axe.release_focus()
            tool_scythe.release_focus()
            tool_pickaxe.release_focus()
            tool_tilling.release_focus()
            tool_watering.release_focus()
            corn.release_focus()
            tomato.release_focus()
            

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
    elif tool == DataTypes.Tools.PlantCorn:
        corn.disabled = false
        corn.focus_mode = Control.FOCUS_ALL
    elif tool == DataTypes.Tools.PlantTomato:
        tomato.disabled = false
        tomato.focus_mode = Control.FOCUS_ALL
    
