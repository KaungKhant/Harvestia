extends CanvasLayer


@onready var continue_button: Button = $Control/ContinueButton
@onready var main_menu_button: Button = $Control/MainMenuButton
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer


func _ready() -> void:
    continue_button.pressed.connect(_on_continue_pressed)
    main_menu_button.pressed.connect(_on_main_menu_pressed)

    animation_player.play("CreditsScroll")
func _on_continue_pressed() -> void:
    print("CONTINUE PLAYING")

    # Resume the current game.
    get_tree().paused = false

    # Remove only the ending UI.
    queue_free()


func _on_main_menu_pressed() -> void:
    print("MAIN MENU")

    get_tree().paused = false

    get_tree().change_scene_to_file(
		"res://main_menu.tscn"
    )
