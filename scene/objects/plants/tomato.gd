extends Node2D

# Preload the scene that spawns when this tomato plant is harvested
var tomato_harvest_scene = preload("res://scene/objects/plants/tomato_harvest.tscn")

# Node References
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_components: GrowthCycleComponents = $GrowthCycleComponents
@onready var hurt_component: HurtComponent = $HurtComponent

# State Variables
var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed
var is_removed: bool = false


func _ready() -> void:
	# Ensure particle effects are off by default
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	# Connect component signals to their respective handler functions
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_components.crop_maturity.connect(on_crop_maturity)
	growth_cycle_components.crop_harvesting.connect(on_crop_harvesting)

func update_sprite():
	sprite_2d.frame_coords = Vector2i(growth_state, 1)
	
func _process(_delta: float) -> void:
	# Keep the visual sprite frame synchronized with the current growth state
	growth_state = growth_cycle_components.get_current_growth_state()
	update_sprite()
	
	# Enable flowering particles if the tomato plant is mature
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true


## Synchronizes the visual elements of the tomato plant when loading a saved game state
func sync_loaded_state() -> void:
	if growth_cycle_components == null:
		return
	
	growth_state = growth_cycle_components.get_current_growth_state()
	update_sprite()
	
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true
		
	if growth_cycle_components.is_watered:
		watering_particles.emitting = false


## Triggered when the plant receives an action (e.g., being hit with a watering can)
func on_hurt(_hit_damage: int) -> void:
	if not growth_cycle_components.is_watered:
		watering_particles.emitting = true
		
		# Keep particles emitting for 5 seconds before turning off
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		growth_cycle_components.is_watered = true


## Triggered by the GrowthCycleComponent when the tomato enters its final growth stage
func on_crop_maturity() -> void:
	flowering_particles.emitting = true


## Triggered when the player successfully harvests the tomato plant
func on_crop_harvesting() -> void:
	if is_removed:
		return
		
	is_removed = true
	growth_cycle_components.harvested = true

	# Instantiate and place the collectible tomato item into the world
	var harvest = tomato_harvest_scene.instantiate()
	harvest.global_position = global_position
	get_parent().add_child(harvest)

	# Delete the crop instance from the field
	queue_free()
