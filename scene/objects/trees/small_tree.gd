class_name SmallTree
extends Sprite2D

@export var log_drop_amount: int = 1

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scene/objects/trees/log.tscn")
var is_chopped: bool = false
var chopped_on_day: int = -1
const RESPAWN_DAYS: int = 5

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_hurt(hit_damage: int) -> void:
	if is_chopped:
		return
	
	damage_component.apply_damage(hit_damage)
	
	if material:
		material.set_shader_parameter("shake_intensity", 0.5)
		await get_tree().create_timer(0.2).timeout 
		material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damaged_reached() -> void:
	if is_chopped:
		return
	is_chopped = true
	chopped_on_day = DayAndNightCycleManager.current_day

	print("max damaged reached")
	
	# Clear player prompt if they were targeting this tree
	var world_node = get_tree().current_scene
	var player = world_node.get_node_or_null("Player")
	if player and player.active_tree == self:
		player.active_tree = null

	hide()
	disable_tree_physics()
	add_log_scene()

func disable_tree_physics() -> void:
	hurt_component.set_deferred("monitoring", false)
	hurt_component.set_deferred("monitorable", false)
	
	var hurt_shape = hurt_component.get_node_or_null("CollisionShape2D")
	if hurt_shape:
		hurt_shape.set_deferred("disabled", true)

	var trunk_collision = get_node_or_null("StaticBody2D/CollisionShape2D")
	if trunk_collision:
		trunk_collision.set_deferred("disabled", true)

func enable_tree_physics() -> void:
	hurt_component.set_deferred("monitoring", true)
	hurt_component.set_deferred("monitorable", true)
	
	var hurt_shape = hurt_component.get_node_or_null("CollisionShape2D")
	if hurt_shape:
		hurt_shape.set_deferred("disabled", false)

	var trunk_collision = get_node_or_null("StaticBody2D/CollisionShape2D")
	if trunk_collision:
		trunk_collision.set_deferred("disabled", false)

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

func on_time_tick_day(day: int) -> void:
	if not is_chopped:
		return
	
	if day >= chopped_on_day + RESPAWN_DAYS:
		respawn_tree()

func respawn_tree() -> void:
	is_chopped = false
	chopped_on_day = -1
	
	if damage_component:
		damage_component.reset_damage()
	
	show()
	enable_tree_physics()
	print("Tree respawned!")
