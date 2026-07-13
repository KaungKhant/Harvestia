extends CanvasLayer

@onready var quest_name = $MarginContainer/PanelContainer/VBoxContainer/QuestNameLabel
@onready var description = $MarginContainer/PanelContainer/VBoxContainer/DescriptionLabel
@onready var progress = $MarginContainer/PanelContainer/VBoxContainer/ProgressLabel

func _ready() -> void:
    hide()

    QuestManager.quest_started.connect(on_quest_started)
    QuestManager.quest_updated.connect(on_quest_updated)
    QuestManager.quest_completed.connect(on_quest_completed)


func on_quest_started(quest: QuestData) -> void:
    show()

    var icon := "•"

    match quest.quest_icon:
        "corn":
            icon = "🌽"
        "tomato":
            icon = "🍅"
        "log":
            icon = "🪵"
        "stone":
            icon = "🪨"

    quest_name.text = icon + " " + quest.description
    description.text = quest.quest_name

    update_progress(0, quest.target_amount)


func on_quest_updated(current: int, target: int) -> void:
    update_progress(current, target)


func on_quest_completed(quest: QuestData) -> void:
    hide()


func update_progress(current: int, target: int) -> void:

    # Change icon depending on quest item
    var icon := "•"

    match QuestManager.current_quest.quest_icon:
        "corn":
            icon = "🌽"

        "tomato":
            icon = "🍅"

        "log":
            icon = "🪵"

        "stone":
            icon = "🪨"

    # If objective is finished, tell the player what to do
    if QuestManager.current_state == QuestManager.QuestState.READY_TO_TURN_IN:
        progress.text = "✔ Objective Complete\nReturn to Guide"
    else:
        progress.text = icon + " " + str(current) + " / " + str(target)
