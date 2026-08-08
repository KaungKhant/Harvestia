class_name Bush
extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var is_chopped: bool = false
var chopped_on_day: int = -1
const RESPAWN_DAYS: int = 2 # Adjust respawn days for bushes as you like

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	
	# Listen to day changes from your manager
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)


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

	# Record the day the bush was destroyed
	chopped_on_day = DayAndNightCycleManager.current_day

	print("Bush max damaged reached")
	
	# Clear player's active target prompt if they were targeting this bush
	var world_node = get_tree().current_scene
	var player = world_node.get_node_or_null("Player")
	if player and player.active_tree == self:
		player.active_tree = null

	hide()
	
	# Safely disable all components and collisions
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


func on_time_tick_day(day: int) -> void:
	# Only check if the bush is currently destroyed
	if not is_chopped:
		return
	
	# Check if respawn days have passed since it was destroyed
	if day >= chopped_on_day + RESPAWN_DAYS:
		respawn_bush()


func respawn_bush() -> void:
	is_chopped = false
	chopped_on_day = -1
	
	# Reset the damage component health back to 0
	if damage_component:
		damage_component.reset_damage()
	
	# Show the bush sprite again
	show()
	
	# Turn collisions and detection back on
	enable_bush_physics()
	print("Bush respawned!")
