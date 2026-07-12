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
    else:
        dialogue = QuestManager.current_quest.dialogue_file

    balloon.start(
        dialogue,
        QuestManager.get_dialogue_label()
)

func on_teach_farming() -> void:
    # Farming basics only
    ToolManager.enable_tool_button(DataTypes.Tools.TillGround)
    ToolManager.enable_tool_button(DataTypes.Tools.WaterCrops)
    ToolManager.enable_tool_button(DataTypes.Tools.PlantCorn)
