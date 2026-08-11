extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool = false


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
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

	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)

	var dialogue: DialogueResource

	# Grandfather story (only once)
	if QuestManager.is_quest_completed("cow_care") \
	and PlayerProgressManager.talked_to_rowan_after_cow_care \
	and !PlayerProgressManager.talked_to_village_elder:

		dialogue = load("res://Dialog/VillageElder/grandfather_story.dialogue")
		balloon.start(dialogue, "start")

	# Normal dialogue
	else:
		dialogue = load("res://Dialog/VillageElder/default.dialogue")
		balloon.start(dialogue, "start")
