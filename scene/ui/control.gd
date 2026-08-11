extends Control

# --- Guide Node References ---
# --- Guide Node References ---
@onready var guide_button: Button = $Guide
@onready var guide_popup: Control = $Guide/GuidePopup # Changed from $Guide/GuidePopup
@onready var close_guide_button: Button = $Guide/GuidePopup/TextureRect/CloseButton # Or $GuidePopup/CloseButton depending on where it is nested inside the popup

# --- Exit Node References ---
@onready var exit_button: Button = $Exit
@onready var exit_popup: Control = $ExitPopup
@onready var confirm_delete_button: Button = $ExitPopup/VBoxContainer/HBoxContainer/ConfirmDeleteButton
@onready var cancel_button: Button = $ExitPopup/VBoxContainer/HBoxContainer/CancelButton

func _ready() -> void:
	# 1. Initialize popups to hidden at startup
	if guide_popup:
		guide_popup.visible = false
	if exit_popup:
		exit_popup.visible = false
	
	# 2. Connect Guide Button Signals
	if guide_button and not guide_button.pressed.is_connected(_on_guide_pressed):
		guide_button.pressed.connect(_on_guide_pressed)
		
	if close_guide_button and not close_guide_button.pressed.is_connected(_on_close_guide_pressed):
		close_guide_button.pressed.connect(_on_close_guide_pressed)

	# 3. Connect Exit Button Signals
	if exit_button and not exit_button.pressed.is_connected(_on_exit_pressed):
		exit_button.pressed.connect(_on_exit_pressed)
		
	if confirm_delete_button and not confirm_delete_button.pressed.is_connected(_on_confirm_exit_pressed):
		confirm_delete_button.pressed.connect(_on_confirm_exit_pressed)
		
	if cancel_button and not cancel_button.pressed.is_connected(_on_cancel_exit_pressed):
		cancel_button.pressed.connect(_on_cancel_exit_pressed)

# --- Guide Handlers ---
func _on_guide_pressed() -> void:
	if guide_popup:
		guide_popup.visible = true
		guide_popup.move_to_front() # Brings the guide image directly on top

func _on_close_guide_pressed() -> void:
	if guide_popup:
		guide_popup.visible = false

# --- Exit Handlers ---
func _on_exit_pressed() -> void:
	if exit_popup:
		exit_popup.visible = true
		exit_popup.move_to_front() # Brings the exit popup directly on top

func _on_confirm_exit_pressed() -> void:
	get_tree().quit()

func _on_cancel_exit_pressed() -> void:
	if exit_popup:
		exit_popup.visible = false
