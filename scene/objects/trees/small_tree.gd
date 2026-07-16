extends Sprite2D

# Allows you to change the log amount for each tree size in the Inspector
@export var log_drop_amount: int = 1

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scene/objects/trees/log.tscn")
var is_chopped: bool = false

func _ready() -> void:
  hurt_component.hurt.connect(on_hurt)
  damage_component.max_damaged_reached.connect(on_max_damaged_reached)


func on_hurt(hit_damage: int) -> void:
  # Ignore hits if the tree is already chopped down
  if is_chopped:
    return
  
  damage_component.apply_damage(hit_damage)
  
  # Safety check to prevent crashing if no material/shader is assigned
  if material:
    material.set_shader_parameter("shake_intensity", 0.5)
    await get_tree().create_timer(0.2).timeout 
    material.set_shader_parameter("shake_intensity", 0.0)


func on_max_damaged_reached() -> void:
  # Prevent this from triggering multiple times
  if is_chopped:
    return
  is_chopped = true

  print("max damaged reached")
  hide()
  
  # Safely disable all components and collisions
  disable_tree_physics()
  
  # Spawn the rewards
  add_log_scene()


func disable_tree_physics() -> void:
  # 1. Turn off the HurtComponent areas so it stops detecting axe swings
  hurt_component.set_deferred("monitoring", false)
  hurt_component.set_deferred("monitorable", false)
  
  # 2. Disable the HurtComponent's internal collision shape if it has one
  var hurt_shape = hurt_component.get_node_or_null("CollisionShape2D")
  if hurt_shape:
    hurt_shape.set_deferred("disabled", true)

  # 3. Disable the solid trunk collision so the player can walk through it
  var trunk_collision = get_node_or_null("StaticBody2D/CollisionShape2D")
  if trunk_collision:
    trunk_collision.set_deferred("disabled", true)


func add_log_scene() -> void:
  if not log_scene:
    return
  
  var spawn_origin = global_position
  var world_node = get_tree().current_scene
  
  for i in range(log_drop_amount):
    var log_instance = log_scene.instantiate() as Node2D
    var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
    
    log_instance.global_position = spawn_origin + random_offset
    world_node.add_child.call_deferred(log_instance)
