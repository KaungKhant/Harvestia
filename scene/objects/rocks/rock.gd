extends Sprite2D

# Allows you to change the log amount for each tree size in the Inspector
@export var stone_drop_amount: int = 1

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var stone_scene = preload("res://scene/objects/rocks/stone.tscn")

func _ready() -> void:
 hurt_component.hurt.connect(on_hurt)
 damage_component.max_damaged_reached.connect(on_max_damaged_reached)


func on_hurt(hit_damage: int) -> void:
 damage_component.apply_damage(hit_damage)
 
 # Safety check to prevent crashing if no material/shader is assigned
 if material:
  material.set_shader_parameter("shake_intensity", 0.5)
  await get_tree().create_timer(0.2).timeout # Reduced from 1.0 to 0.2 so the tree doesn't shake for too long
  material.set_shader_parameter("shake_intensity", 0.0)


func on_max_damaged_reached() -> void:
 # Call spawning BEFORE queue_free to guarantee we grab the correct coordinates
 add_stone_scene()
 print("max damaged reached")
 queue_free()


func add_stone_scene() -> void:
 if not stone_scene:
  return
  
 # Store the current world position right now before the tree is deleted
 var spawn_origin = global_position
 
 # Access the main level/world layer so the log isn't bound to the tree's parent offsets
 var world_node = get_tree().current_scene
 
 for i in range(stone_drop_amount):
  var stone_instance = stone_scene.instantiate() as Node2D
  
  # Give logs a tiny random offset so they don't stack perfectly
  var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
  
  # Set the position on the instance BEFORE safely deferring its entry into the tree
  stone_instance.global_position = spawn_origin + random_offset
  
  # Spawn the log safely after the physics calculation frame finishes
  world_node.add_child.call_deferred(stone_instance)
