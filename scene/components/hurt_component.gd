class_name HurtComponent
extends Area2D

@export var tool : DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _on_area_entered(area: Area2D) -> void:
 var hit_component = area as HitComponent
 
 # 1. Safety check to make sure the overlapping area actually IS a HitComponent
 if hit_component:
  # 2. Print both values to the console so you can see the mismatch
  print("Expects: ", tool, " | Sent: ", hit_component.current_tool)
  
  # 3. Check if they match
  if tool == hit_component.current_tool:
   hurt.emit(hit_component.hit_damage)
