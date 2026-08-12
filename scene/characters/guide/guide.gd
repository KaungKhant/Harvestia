extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

	GameDialogueManager.teach_farming.connect(on_teach_farming)
	GameDialogueManager.give_axe.connect(on_give_axe)
	GameDialogueManager.give_pickaxe.connect(on_give_pickaxe)


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

	# -------------------------------------------------
	# Story Progression
	# -------------------------------------------------

	# Chicken Care -> Carrot Harvest
	if QuestManager.is_quest_completed("chicken_care") \
	and !QuestManager.is_quest_completed("carrot_harvest") \
	and (QuestManager.current_quest == null \
	or QuestManager.current_quest.quest_id != "carrot_harvest"):

		QuestManager.start_quest("carrot_harvest")

	# Carrot Harvest -> The Silent Barn
	elif QuestManager.is_quest_completed("carrot_harvest") \
	and !QuestManager.is_quest_completed("restore_cow_barn") \
	and (QuestManager.current_quest == null \
	or QuestManager.current_quest.quest_id != "restore_cow_barn"):

		QuestManager.start_quest("restore_cow_barn")
		
	# Cow Care -> Village Elder / Last Pumpkin
	elif QuestManager.is_quest_completed("cow_care") \
	and !QuestManager.is_quest_completed("last_pumpkin"):

		if PlayerProgressManager.talked_to_village_elder:
			QuestManager.start_quest("last_pumpkin")
	
	# Last Pumpkin -> Homecoming
	elif QuestManager.is_quest_completed("last_pumpkin") \
	and !QuestManager.is_quest_completed("homecoming") \
	and (QuestManager.current_quest == null \
	or QuestManager.current_quest.quest_id != "homecoming"):

		QuestManager.start_quest("homecoming")	

	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)

	var dialogue: DialogueResource

	# Intro before the first quest
	if QuestManager.current_quest == null:
		dialogue = load("res://Dialog/Guide/intro.dialogue")
		balloon.start(dialogue, "start")
	
	# Homecoming dialogue
	elif QuestManager.current_quest.quest_id == "homecoming":
		dialogue = load("res://Dialog/Guide/homecoming.dialogue")
		balloon.start(
		dialogue,
		QuestManager.get_dialogue_label()
	)
	# Guide handles Guide quests only
	elif QuestManager.current_quest.quest_giver == "Uncle Rowan":
		dialogue = QuestManager.current_quest.dialogue_file
		balloon.start(
			dialogue,
			QuestManager.get_dialogue_label()
		)

	# Default Guide dialogue
	else:
		dialogue = load("res://Dialog/Guide/default.dialogue")

		if QuestManager.is_quest_completed("cow_care") \
		and !PlayerProgressManager.talked_to_village_elder:
			
			PlayerProgressManager.talked_to_rowan_after_cow_care = true
			balloon.start(dialogue, "after_cow_care")
		else:
			balloon.start(dialogue, "start")


func on_teach_farming() -> void:
	ToolManager.enable_tool_button(DataTypes.Tools.TillGround)
	NotificationManager.show_tool("Hoe")

	ToolManager.enable_tool_button(DataTypes.Tools.WaterCrops)
	NotificationManager.show_tool("Watering Can")

	ToolManager.enable_tool_button(DataTypes.Tools.Scythe)
	NotificationManager.show_tool("Scythe")

	ToolManager.enable_tool_button(DataTypes.Tools.PlantCorn)


func on_give_axe() -> void:
	ToolManager.enable_tool_button(DataTypes.Tools.AxeWood)
	NotificationManager.show_tool("Axe")


func on_give_pickaxe() -> void:
	ToolManager.enable_tool_button(DataTypes.Tools.Pickaxe)
	NotificationManager.show_tool("Pickaxe")
