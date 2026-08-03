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
	elif tool == DataTypes.Tools.PlantCarrot:
		if inventory.get("carrot_seeds", 0) <= 0:
			print("Cannot select Carrot: 0 seeds remaining!")
			return
			
	elif tool == DataTypes.Tools.PlantPumpkin:
		if inventory.get("pumpkin_seeds", 0) <= 0:
			print("Cannot select Pumpkin: 0 seeds remaining!")
			return

	selected_tool = tool
	tool_selected.emit(tool)

var unlocked_tools:Array[int] = []

func enable_tool_button(tool):
	if tool not in unlocked_tools:
		unlocked_tools.append(tool)

	enable_tool.emit(tool)

func restore_tools_from_progress() -> void:
	if QuestManager.is_quest_completed("first_harvest"):
		enable_tool_button(DataTypes.Tools.TillGround)
		enable_tool_button(DataTypes.Tools.WaterCrops)
	if QuestManager.is_quest_completed("forest_unlock"):
		enable_tool_button(DataTypes.Tools.AxeWood)

  # Add your other quest → tool unlocks here
