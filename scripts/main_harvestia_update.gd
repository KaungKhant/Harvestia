extends Node2D
@onready var save_level_data_component: SaveLevelDataComponent = $SaveLevelDataComponent

func _ready():
    await get_tree().process_frame
    save_level_data_component.load_game()
    var player = get_tree().get_first_node_in_group("player")

    if SceneTransition.outside_spawn_position != Vector2.ZERO:
        player.global_position = SceneTransition.outside_spawn_position
        SceneTransition.outside_spawn_position = Vector2.ZERO
