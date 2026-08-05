extends Control

@onready var delete_popup : Control = $DeletePopup
@onready var label_message : Label = $DeletePopup/VBoxContainer/LabelMessage
@onready var confirm_delete_button : Button = $DeletePopup/VBoxContainer/HBoxContainer/ConfirmDeleteButton
@onready var cancel_button : Button = $DeletePopup/VBoxContainer/HBoxContainer/CancelButton

# New Game Popup Node References
@onready var new_game_popup : Control = $NewGamePopup
@onready var new_game_label_message : Label = $NewGamePopup/VBoxContainer/LabelMessage
@onready var confirm_new_game_button : Button = $NewGamePopup/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_new_game_button : Button = $NewGamePopup/VBoxContainer/HBoxContainer/CancelButton

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
	
	# Connect your delete popup buttons
	confirm_delete_button.pressed.connect(_on_delete_confirmed)
	cancel_button.pressed.connect(_on_cancel_delete_pressed)
	
	# Connect your new game popup buttons
	confirm_new_game_button.pressed.connect(_on_new_game_confirmed)
	cancel_new_game_button.pressed.connect(_on_cancel_new_game_pressed)
	
	# Hide the popups initially when the scene starts
	delete_popup.hide()
	new_game_popup.hide()

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

	update_buttons()


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
		update_buttons()
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

	# Check if a save file already exists for the current profile
	if ProfileSaveManager.current_profile_has_save():
		var current_profile = ProfileManager.get_profile()
		new_game_label_message.text = "Start a new game for \"%s\"?\n\nExisting progress will be overwritten." % current_profile
		new_game_popup.show()
	else:
		# If no save exists, start the new game immediately without prompting
		_execute_new_game()


func _on_cancel_new_game_pressed():
	new_game_popup.hide()


func _on_new_game_confirmed():
	new_game_popup.hide()
	_execute_new_game()


func _execute_new_game():
	ProfileSaveManager.start_new_game()
	SceneManager.start_game()


func _on_continue_pressed():
	if !ProfileManager.has_profile():
		return

	SceneManager.start_game()


func _on_delete_profile_pressed():
	if profile_dropdown.item_count == 0:
		return

	var profile_to_delete = ProfileManager.get_profile()

	# Update the custom label text inside your DeletePopup container
	label_message.text = "Delete \"%s\"?\n\nThis action cannot be undone." % profile_to_delete

	# Show your custom popup panel
	delete_popup.show()


func _on_cancel_delete_pressed():
	delete_popup.hide()


func _on_delete_confirmed():
	delete_popup.hide()
	
	var profile_to_delete = ProfileManager.get_profile()
	print("Deleting:", profile_to_delete)

	ProfileDatabase.delete_profile(profile_to_delete)
	refresh_profiles()

	if profile_dropdown.item_count > 0:
		var next_profile = profile_dropdown.get_item_text(0)
		ProfileManager.set_profile(next_profile)
	else:
		ProfileManager.clear_profile()

	update_buttons()


func _on_exit_pressed() -> void:
	get_tree().quit()
