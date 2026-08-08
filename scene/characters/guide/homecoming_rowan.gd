extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool = false
var homecoming_board: CanvasLayer = null


func _ready() -> void:
	interactable_component.interactable_activated.connect(
		on_interactable_activated
	)

	interactable_component.interactable_deactivated.connect(
		on_interactable_deactivated
	)
	
	GameDialogueManager.open_homecoming_board.connect(
	on_open_homecoming_board
	)
	
	HomecomingManager.donation_completed_signal.connect(
	on_homecoming_donated
	)
	
	interactable_label_component.hide()


func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true


func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if !in_range:
		return

	if !event.is_action_pressed("show_dialogue"):
		return

	# Re-check Homecoming progress before choosing dialogue.
	if QuestManager.current_quest != null \
	and QuestManager.current_quest.quest_id == "homecoming":
		QuestManager.sync_progress_with_inventory()

	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)

	var dialogue: DialogueResource = load(
		"res://Dialog/Guide/homecoming.dialogue"
	)

	balloon.start(
		dialogue,
		QuestManager.get_dialogue_label()
	)

func on_open_homecoming_board() -> void:
	print("HomecomingRowan: Opening Homecoming Board.")

	# If the board already exists, reuse it.
	if is_instance_valid(homecoming_board):
		homecoming_board.open()
		print("HomecomingBoard already exists - reopened existing board.")
		return

	var board_scene = preload(
		"res://scene/progress/HomecomingBoard.tscn"
	)

	homecoming_board = board_scene.instantiate()

	if homecoming_board == null:
		print("ERROR: HomecomingBoard failed to instantiate.")
		return

	get_tree().current_scene.add_child(homecoming_board)

	homecoming_board.open()

	print("HomecomingBoard created and opened.")

func on_homecoming_donated() -> void:
	print("HomecomingRowan: Donation completed. Starting after_donation dialogue.")

	var dialogue: DialogueResource = load(
		"res://Dialog/Guide/homecoming.dialogue"
	)

	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)

	balloon.start(
		dialogue,
		"after_donation"
	)
