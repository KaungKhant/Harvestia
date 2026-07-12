class_name Player
extends CharacterBody2D

# 1. GET A REFERENCE TO YOUR HITCOMPONENT CHILD NODE
# (Make sure "$HitComponent" matches the exact name of the node in your player scene!)
@onready var hit_component = $HitComponent 

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

func _ready() -> void:
 # Listen to the global ToolManager's signal
 ToolManager.tool_selected.connect(_on_tool_selected)

func _on_tool_selected(new_tool: DataTypes.Tools) -> void:
 current_tool = new_tool
 print("Player's holding tool: ", current_tool)
 
 # 2. PASS THE NEW TOOL TO THE HITCOMPONENT IMMEDIATELY
 if hit_component:
  hit_component.current_tool = new_tool

# ─── HOTKEY INPUT LISTENER (O and P Keys) ───
func _unhandled_input(event: InputEvent) -> void:
 if event.is_action_pressed("next_tool"):
  cycle_tool(1)   
 elif event.is_action_pressed("prev_tool"):
  cycle_tool(-1)  

func cycle_tool(direction: int) -> void:
 var tools_list = DataTypes.Tools.values()
 var current_index = tools_list.find(current_tool)
 
 var new_index = (current_index + direction) % tools_list.size()
 if new_index < 0:
  new_index = tools_list.size() - 1
  
 var chosen_tool = tools_list[new_index]
 
 ToolManager.select_tool(chosen_tool)
