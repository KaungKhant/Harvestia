extends Control

@onready var profile_dropdown : OptionButton = $ProfileDropDown
@onready var profile_name : LineEdit = $NewAccount

@onready var create_button : Button = $CreateAccount
@onready var new_game : Button = $New_Game
@onready var continue_game : Button = $Continue


func _ready():

	create_button.pressed.connect(_on_create_pressed)

	new_game.pressed.connect(_on_new_game_pressed)

	continue_game.pressed.connect(_on_continue_pressed)

	profile_dropdown.item_selected.connect(_on_profile_selected)

	refresh_profiles()

	update_buttons()


func refresh_profiles():

	profile_dropdown.clear()

	var profiles = ProfileDatabase.get_profiles()

	for profile in profiles:
		profile_dropdown.add_item(profile)

	if profile_dropdown.item_count > 0:
		profile_dropdown.select(0)
		ProfileManager.set_profile(profile_dropdown.get_item_text(0))

	update_buttons()   # <-- Add this

func update_buttons():

	var has_profile = profile_dropdown.item_count > 0

	print("Profiles:", profile_dropdown.item_count)
	print("Has Profile:", has_profile)

	new_game.disabled = !has_profile
	continue_game.disabled = !has_profile

func _on_create_pressed():

	var name = profile_name.text

	if ProfileDatabase.create_profile(name):

		refresh_profiles()
		update_buttons()   # <-- Add this

		profile_name.clear()

	else:

		print("Cannot create profile")


func _on_profile_selected(index):

	var profile = profile_dropdown.get_item_text(index)

	ProfileManager.set_profile(profile)


func _on_new_game_pressed():

	if !ProfileManager.has_profile():
		return

	# Change this to your game's first scene
	get_tree().change_scene_to_file("res://scene/test/test_tilemap_save_load.tscn")


func _on_continue_pressed():

	if !ProfileManager.has_profile():
		return

	get_tree().change_scene_to_file("res://scene/test/test_tilemap_save_load.tscn")
