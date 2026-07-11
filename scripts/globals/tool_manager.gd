extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None

signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

func select_tool(tool: DataTypes.Tools) -> void:
	# Protective check: Don't allow selecting seeds if inventory is empty
	var inventory: Dictionary = InventoryManager.inventory
	
	if tool == DataTypes.Tools.PlantCorn:
		if inventory.get("corn_seeds", 0) <= 0:
			print("Cannot select Corn: 0 seeds remaining!")
			return
			
	elif tool == DataTypes.Tools.PlantTomato:
		if inventory.get("tomato_seeds", 0) <= 0:
			print("Cannot select Tomato: 0 seeds remaining!")
			return

	selected_tool = tool
	tool_selected.emit(tool)

func enable_tool_button(tool: DataTypes.Tools) -> void:
	enable_tool.emit(tool)
