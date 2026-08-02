extends Control

@onready var delete_confirmation : ConfirmationDialog = $DeleteConfirmation
@onready var profile_dropdown : OptionButton = $ProfileDropDown
@onready var profile_name : LineEdit = $NewAccount
@onready var delete_profile_button : Button = $Delete
@onready var create_button : Button = $CreateAccount
@onready var new_game : Button = $New_Game
@onready var continue_game : Button = $Continue


func _ready():

	create_button.pressed.connect(_on_create_pressed)

	new_game.pressed.connect(_on_new_game_pressed)

	continue_game.pressed.connect(_on_continue_pressed)

	profile_dropdown.item_selected.connect(_on_profile_selected)
	delete_profile_button.pressed.connect(_on_delete_profile_pressed)
	delete_confirmation.confirmed.connect(_on_delete_confirmed)

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

	if profile_dropdown.item_count == 0:

		new_game.disabled = true
		continue_game.disabled = true
		return

	new_game.disabled = false

	continue_game.disabled = !ProfileSaveManager.current_profile_has_save()

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

	update_buttons()

func _on_new_game_pressed():

	if !ProfileManager.has_profile():
		return

	# Delete ONLY this profile's save.
	ProfileSaveManager.start_new_game()

	SceneManager.start_game()

func _on_continue_pressed():

	if !ProfileManager.has_profile():
		return

	SceneManager.start_game()

func _on_delete_profile_pressed():

	if profile_dropdown.item_count == 0:
		return

	var profile_name = ProfileManager.get_profile()

	delete_confirmation.dialog_text = "Delete  \"%s\"?\n\nThis action cannot be undone." % profile_name

	delete_confirmation.popup_centered()

func _on_delete_confirmed():

	var profile_name = ProfileManager.get_profile()

	print("Deleting:", profile_name)

	ProfileDatabase.delete_profile(profile_name)

	refresh_profiles()

	if profile_dropdown.item_count > 0:

		var next_profile = profile_dropdown.get_item_text(0)

		ProfileManager.set_profile(next_profile)

	else:

		ProfileManager.clear_profile()

	update_buttons()
