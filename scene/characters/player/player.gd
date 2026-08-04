class_name Player
extends CharacterBody2D

@onready var hit_component = $HitComponent 

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

var house = null:
	set(new_house):
		if new_house != null:
			$Key.show()
		else:
			$Key.hide()
		house = new_house
func _ready() -> void:
	if Global.has_pending_pos:
		global_position = Global.player_pos
		Global.has_pending_pos = false
	house = null
	# Listen to the global ToolManager's signal
	ToolManager.tool_selected.connect(_on_tool_selected)
	#PlayerProgressManager.add_gold(250)
	
	await get_tree().create_timer(1.0).timeout
	NotificationManager.show(
	"🌾 Welcome to Harvestia!",
	"Your new farming journey begins."
)

func _on_tool_selected(new_tool: DataTypes.Tools) -> void:
	current_tool = new_tool
	print("Player's holding tool: ", current_tool)
	
	# PASS THE NEW TOOL TO THE HITCOMPONENT IMMEDIATELY
	if hit_component:
		hit_component.current_tool = new_tool

# ─── HOTKEY INPUT LISTENER (O and P Keys) ───
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("interact") and house != null:
		Global.player_pos = global_position
		house.enter()
		
	if event.is_action_pressed("next_tool"):
		cycle_tool(1)   
	elif event.is_action_pressed("prev_tool"):
		cycle_tool(-1)  

func cycle_tool(direction: int) -> void:
	var tools_list = DataTypes.Tools.values()
	var current_index = tools_list.find(current_tool)
	
	var check_index = current_index
	while true:
		check_index = (check_index + direction) % tools_list.size()
		if check_index < 0:
			check_index = tools_list.size() - 1
			
		if check_index == current_index:
			break
			
		var candidate_tool = tools_list[check_index]
		var inventory = InventoryManager.inventory
		
		# Pull from your data storage to see if the tool panel slots have stock left
		if candidate_tool == DataTypes.Tools.PlantCorn and inventory.get("corn_seeds", 0) <= 0:
			continue
		if candidate_tool == DataTypes.Tools.PlantTomato and inventory.get("tomato_seeds", 0) <= 0:
			continue
			
		ToolManager.select_tool(candidate_tool)
		return
