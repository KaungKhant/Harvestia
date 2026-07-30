extends Control

@onready var new_game = $New_Game
@onready var continue_game = $Continue

@onready var profile1 = $Profile_1
@onready var profile2 = $Profile_2
@onready var profile3 = $Profile_3

var selected_profile : String = ""

func _ready():

	profile1.pressed.connect(_on_profile1_pressed)
	profile2.pressed.connect(_on_profile2_pressed)
	profile3.pressed.connect(_on_profile3_pressed)

	new_game.pressed.connect(_on_new_game_pressed)
	continue_game.pressed.connect(_on_continue_pressed)

	new_game.disabled = true
	continue_game.disabled = true


func _on_profile1_pressed():

	selected_profile = "Profile1"
	ProfieManager.set_profile(selected_profile)

	new_game.disabled = false
	continue_game.disabled = false


func _on_profile2_pressed():

	selected_profile = "Profile2"
	ProfieManager.set_profile(selected_profile)

	new_game.disabled = false
	continue_game.disabled = false


func _on_profile3_pressed():

	selected_profile = "Profile3"
	ProfieManager.set_profile(selected_profile)

	new_game.disabled = false
	continue_game.disabled = false


func _on_new_game_pressed():

	print("Starting New Game:", selected_profile)

	# Change this to your first game scene
	get_tree().change_scene_to_file("res://scene/test/test_tilemap_guide_dialog_shop.tscn")


func _on_continue_pressed():

	print("Continue:", selected_profile)

	# Change this to your first game scene
	get_tree().change_scene_to_file("res://scene/test/test_tilemap_guide_dialog_shop.tscn")
