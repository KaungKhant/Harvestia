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

	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)

	var dialogue: DialogueResource

	if QuestManager.current_quest == null:
		dialogue = load("res://Dialog/Guide/intro.dialogue")
		balloon.start(dialogue, "start")

	elif QuestManager.current_quest.quest_giver == "Guide":
		dialogue = QuestManager.current_quest.dialogue_file
		balloon.start(dialogue, QuestManager.get_dialogue_label())

	else:
		dialogue = load("res://Dialog/Guide/default.dialogue")
		balloon.start(dialogue, "start")

	#if QuestManager.current_state == QuestManager.QuestState.START:
		#QuestManager.current_state = QuestManager.QuestState.IN_PROGRESS

func on_teach_farming() -> void:
	# Unlock farming tools
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
