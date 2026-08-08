extends Control

@onready var typing_sound: AudioStreamPlayer = $TypingSound
@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var exit_button: Button = $Exit

# Delete Profile Popup
@onready var delete_popup: Control = $DeletePopup
@onready var label_message: Label = $DeletePopup/VBoxContainer/LabelMessage
@onready var confirm_delete_button: Button = $DeletePopup/VBoxContainer/HBoxContainer/ConfirmDeleteButton
@onready var cancel_button: Button = $DeletePopup/VBoxContainer/HBoxContainer/CancelButton

# New Game Popup
@onready var new_game_popup: Control = $NewGamePopup
@onready var new_game_label_message: Label = $NewGamePopup/VBoxContainer/LabelMessage
@onready var confirm_new_game_button: Button = $NewGamePopup/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_new_game_button: Button = $NewGamePopup/VBoxContainer/HBoxContainer/CancelButton

# Profile Controls
@onready var profile_dropdown: OptionButton = $ProfileDropDown
@onready var profile_name: LineEdit = $NewAccount
@onready var delete_profile_button: Button = $Delete
@onready var create_button: Button = $CreateAccount
@onready var new_game: Button = $New_Game
@onready var continue_game: Button = $Continue

const INTRO_SCENE := "res://scene/ui/intro.tscn"


func _ready() -> void:
    # Connect main buttons
    create_button.pressed.connect(_on_create_pressed)
    new_game.pressed.connect(_on_new_game_pressed)
    continue_game.pressed.connect(_on_continue_pressed)
    profile_name.text_changed.connect(_on_text_changed)

    # Connect profile controls
    profile_dropdown.item_selected.connect(_on_profile_selected)
    delete_profile_button.pressed.connect(_on_delete_profile_pressed)

    # Connect delete popup buttons
    confirm_delete_button.pressed.connect(_on_delete_confirmed)
    cancel_button.pressed.connect(_on_cancel_delete_pressed)

    # Connect new game popup buttons
    confirm_new_game_button.pressed.connect(_on_new_game_confirmed)
    cancel_new_game_button.pressed.connect(_on_cancel_new_game_pressed)

    # Hide popups initially
    delete_popup.hide()
    new_game_popup.hide()

    # Load profiles
    refresh_profiles()
    update_buttons()


func refresh_profiles() -> void:
    profile_dropdown.clear()

    var profiles = ProfileDatabase.get_profiles()

    for profile in profiles:
        profile_dropdown.add_item(profile)

    if profile_dropdown.item_count > 0:
        profile_dropdown.select(0)
        ProfileManager.set_profile(profile_dropdown.get_item_text(0))

    update_buttons()


func update_buttons() -> void:
    if profile_dropdown.item_count == 0:
        new_game.disabled = true
        continue_game.disabled = true
        delete_profile_button.disabled = true
        return

    new_game.disabled = false
    delete_profile_button.disabled = false
    continue_game.disabled = !ProfileSaveManager.current_profile_has_save()


func _on_create_pressed() -> void:
    button_click.play()

    var name := profile_name.text.strip_edges()

    if name.is_empty():
        print("Profile name cannot be empty.")
        return

    if ProfileDatabase.create_profile(name):
        refresh_profiles()
        update_buttons()
        profile_name.clear()
    else:
        print("Cannot create profile.")


func _on_profile_selected(index: int) -> void:
    button_click.play()

    var profile := profile_dropdown.get_item_text(index)
    ProfileManager.set_profile(profile)

    update_buttons()


func _on_new_game_pressed() -> void:
    button_click.play()

    if !ProfileManager.has_profile():
        return

    # Check whether the current profile already has a save
    if ProfileSaveManager.current_profile_has_save():
        var current_profile := ProfileManager.get_profile()

        new_game_label_message.text = (
			"Start a new game for \"%s\"?\n\n"
            + "Existing progress will be overwritten."
        ) % current_profile

        new_game_popup.show()
    else:
        await button_click.finished
        _execute_new_game()


func _on_cancel_new_game_pressed() -> void:
    button_click.play()
    new_game_popup.hide()


func _on_new_game_confirmed() -> void:
    button_click.play()
    new_game_popup.hide()

    await button_click.finished
    _execute_new_game()


func _execute_new_game() -> void:
    if !ProfileManager.has_profile():
        return

    ProfileSaveManager.start_new_game()

    get_tree().change_scene_to_file(INTRO_SCENE)


func _on_continue_pressed() -> void:
    button_click.play()

    if !ProfileManager.has_profile():
        return

    if !ProfileSaveManager.current_profile_has_save():
        return

    await button_click.finished

    # Use your existing SceneManager if this is how
    # your project loads a saved game.
    SceneManager.start_game()


func _on_delete_profile_pressed() -> void:
    button_click.play()

    if profile_dropdown.item_count == 0:
        return

    var profile_to_delete := ProfileManager.get_profile()

    label_message.text = (
		"Delete \"%s\"?\n\n"
        + "This action cannot be undone."
    ) % profile_to_delete

    delete_popup.show()


func _on_cancel_delete_pressed() -> void:
    button_click.play()
    delete_popup.hide()


func _on_delete_confirmed() -> void:
    button_click.play()

    var profile_to_delete := ProfileManager.get_profile()

    print("Deleting: ", profile_to_delete)

    delete_popup.hide()

    ProfileDatabase.delete_profile(profile_to_delete)

    refresh_profiles()

    if profile_dropdown.item_count > 0:
        var next_profile := profile_dropdown.get_item_text(0)
        ProfileManager.set_profile(next_profile)
    else:
        ProfileManager.clear_profile()

    update_buttons()


func _on_text_changed(new_text: String) -> void:
    typing_sound.stop()

    if !new_text.is_empty():
        typing_sound.play()


func _on_exit_pressed() -> void:
    button_click.play()

    await button_click.finished

    get_tree().quit()
