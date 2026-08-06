extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool = false


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)

	interactable_label_component.hide()

	GameDialogueManager.transfer_cow_barn.connect(on_transfer_cow_barn)


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

	# This NPC only handles quests given by the Cow Barn Owner.
	if QuestManager.current_quest != null \
	and QuestManager.current_quest.quest_giver == "Cow Barn Owner":

		dialogue = QuestManager.current_quest.dialogue_file

		# Only The Silent Barn has a level requirement.
		if QuestManager.current_quest.quest_id == "restore_cow_barn" \
		and PlayerProgressManager.player_level < 12:
			balloon.start(dialogue, "level_too_low")
		else:
			var label := QuestManager.get_dialogue_label()
			balloon.start(dialogue, label)

			# After the first conversation, make the quest ready to turn in.
			if QuestManager.current_quest.quest_id == "restore_cow_barn" \
			and label == "progress":
				QuestManager.mark_ready_to_turn_in()

	# No active Cow Barn Owner quest.
	else:
		dialogue = load("res://Dialog/CowBarnOwner/default.dialogue")
		balloon.start(dialogue, "start")


func on_transfer_cow_barn() -> void:
	# Level is already checked before opening the dialogue.

	if !PlayerProgressManager.spend_gold(1000):
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().current_scene.add_child(balloon)

		var dialogue := load("res://Dialog/CowBarnOwner/the_silent_barn.dialogue")
		balloon.start(dialogue, "not_enough_gold")
		return

	# Complete the ownership quest.
	if QuestManager.try_complete_quest():
		PlayerProgressManager.owns_cow_barn = true

		NotificationManager.show("🐄 Cow Barn Ownership Transferred!")

		# Start the next quest.
		QuestManager.start_quest("cow_care")
