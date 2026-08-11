class_name Bush
extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var is_chopped: bool = false
var chopped_on_day: int = -1

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	# Day listening removed so the bush will never respawn


func on_hurt(hit_damage: int) -> void:
	# Ignore hits if the bush is already destroyed
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

	# Record the day the bush was destroyed (kept just in case you need it for reference)
	chopped_on_day = DayAndNightCycleManager.current_day

	print("Bush max damaged reached")
	
	# Clear player's active target prompt if they were targeting this bush
	var world_node = get_tree().current_scene
	var player = world_node.get_node_or_null("Player")
	if player and player.active_tree == self:
		player.active_tree = null

	hide()
	
	# Safely disable all components and collisions permanently
	disable_bush_physics()
	
	# No resource items are spawned for bushes


func disable_bush_physics() -> void:
	# 1. Turn off the HurtComponent areas so it stops detecting tool swings
	hurt_component.set_deferred("monitoring", false)
	hurt_component.set_deferred("monitorable", false)
	
	# 2. Disable the HurtComponent's internal collision shape if it has one
	var hurt_shape = hurt_component.get_node_or_null("CollisionShape2D")
	if hurt_shape:
		hurt_shape.set_deferred("disabled", true)

	# 3. Disable the solid collision so the player can walk through it
	var trunk_collision = get_node_or_null("StaticBody2D/CollisionShape2D")
	if trunk_collision:
		trunk_collision.set_deferred("disabled", true)


func enable_bush_physics() -> void:
	# Re-enable HurtComponent areas
	hurt_component.set_deferred("monitoring", true)
	hurt_component.set_deferred("monitorable", true)
	
	# Re-enable HurtComponent's internal collision shape
	var hurt_shape = hurt_component.get_node_or_null("CollisionShape2D")
	if hurt_shape:
		hurt_shape.set_deferred("disabled", false)

	# Re-enable solid collision so the player can collide with it again
	var trunk_collision = get_node_or_null("StaticBody2D/CollisionShape2D")
	if trunk_collision:
		trunk_collision.set_deferred("disabled", false)
