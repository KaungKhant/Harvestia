extends Control

const MAIN_MENU := "res://main_menu.tscn"
const MAIN_WORLD := "res://scene/test/main_harvestia_update.tscn"

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_WORLD)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
