class_name CropDataResource
extends NodeDataResource

@export var scene_file_path: String = ""
# 🟢 FIX: Added this declaration so the script can save coordinates!
@export var current_growth_state: int
@export var is_watered: bool
@export var starting_day: int
@export var growth_progress: int
@export var is_removed: bool = false

func _save_data(node: Node) -> void:
    super._save_data(node)

    var crop := node as Node2D
    if crop == null:
        return
    
    is_removed = crop.is_removed
    scene_file_path = crop.scene_file_path
    global_position = crop.global_position

    var growth = crop.get_node_or_null("GrowthCycleComponents")

    if growth:
        current_growth_state = growth.current_growth_state
        is_watered = growth.is_watered
        starting_day = growth.starting_day
        growth_progress = growth.growth_progress
func _load_data(source_node: Node) -> void:

    var crop = source_node as Node2D

    if crop == null:
        return

    is_removed = crop.is_removed

    if is_removed:
        return

    crop.global_position = global_position

    var growth = crop.get_node_or_null("GrowthCycleComponents")

    if growth:
        growth.current_growth_state = current_growth_state
        growth.is_watered = is_watered
        growth.starting_day = starting_day
        growth.growth_progress = growth_progress

        # Prevent immediate growth after loading
        growth.just_loaded = true
