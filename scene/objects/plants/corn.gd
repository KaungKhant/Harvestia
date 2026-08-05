extends Node2D

# 🟢 FIX: Removed the duplicate '@export var scene_file_path' definition!
# Godot already provides 'scene_file_path' automatically for all nodes.

var corn_harvest_scene = preload("res://scene/objects/plants/corn_harvest.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_components: GrowthCycleComponents = $GrowthCycleComponents
@onready var hurt_component: HurtComponent = $HurtComponent
var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed
var is_removed: bool = false

func _ready() -> void:
    watering_particles.emitting = false
    flowering_particles.emitting = false
    
    hurt_component.hurt.connect(on_hurt)
    growth_cycle_components.crop_maturity.connect(on_crop_maturity)
    growth_cycle_components.crop_harvesting.connect(on_crop_harvesting)

func update_sprite():
    sprite_2d.frame_coords = Vector2i(growth_state, 0)
    
func _process(delta: float) -> void:
    growth_state = growth_cycle_components.get_current_growth_state()
    update_sprite()
    
    if growth_state == DataTypes.GrowthStates.Maturity:
        flowering_particles.emitting = true


func sync_loaded_state() -> void:
    if growth_cycle_components == null:
        return
    
    growth_state = growth_cycle_components.get_current_growth_state()
    update_sprite()
    
    if growth_state == DataTypes.GrowthStates.Maturity:
        flowering_particles.emitting = true
        
    if growth_cycle_components.is_watered:
        watering_particles.emitting = false
    print("Frame before:", sprite_2d.frame)
    print("Growth state:", growth_cycle_components.current_growth_state)
    print("Texture:", sprite_2d.texture)
    print("Hframes:", sprite_2d.hframes)
    print("Vframes:", sprite_2d.vframes)

    growth_state = growth_cycle_components.current_growth_state
    update_sprite()

    print("Frame after:", sprite_2d.frame)

func on_hurt(hit_damage: int) -> void:
    if !growth_cycle_components.is_watered:
        watering_particles.emitting = true
        await get_tree().create_timer(5.0).timeout
        watering_particles.emitting = false
        growth_cycle_components.is_watered = true


func on_crop_maturity() -> void:
    flowering_particles.emitting = true


func on_crop_harvesting() -> void:
    growth_cycle_components.harvested = true

    var harvest = corn_harvest_scene.instantiate()
    harvest.global_position = global_position
    get_parent().add_child(harvest)

    queue_free()
