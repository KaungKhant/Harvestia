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
