extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)

	interactable_label_component.hide()
	
	GameDialogueManager.transfer_chicken_coop.connect(on_transfer_chicken_coop)


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

	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)

	var dialogue: DialogueResource

	if QuestManager.current_quest != null \
	and QuestManager.current_quest.quest_id == "a_new_caretaker":
		dialogue = QuestManager.current_quest.dialogue_file

		balloon.start(
			dialogue,
			QuestManager.get_dialogue_label()
		)
	else:
		dialogue = load("res://Dialog/ChickenCoopOwner/default.dialogue")
		balloon.start(dialogue, "start")

func on_transfer_chicken_coop() -> void:
	if PlayerProgressManager.player_level < 11:
		NotificationManager.show("You must reach Level 5 before taking over the Chicken Coop.")
		return
	
	if !PlayerProgressManager.spend_gold(500):
		NotificationManager.show("You need 500 Gold to restore the Chicken Coop.")
		return

	# Complete the quest and give rewards
	if QuestManager.try_complete_quest():
		PlayerProgressManager.owns_chicken_coop = true
		
		NotificationManager.show("🐔 Chicken Coop Ownership Transferred!")

		# Start the next quest
		QuestManager.start_quest("feed_the_chickens")
