class_name QuestSaveDataResource
extends NodeDataResource

@export var current_quest_id: String = ""
@export var current_state: int = 0
@export var current_progress: int = 0
@export var completed_quests: Dictionary = {}

func _save_data(node: Node) -> void:
	if QuestManager.current_quest != null:
		current_quest_id = QuestManager.current_quest.quest_id
	else:
		current_quest_id = ""

	current_state = QuestManager.current_state
	current_progress = QuestManager.current_progress
	completed_quests = QuestManager.completed_quests.duplicate(true)


func _load_data(source_node: Node) -> void:
	QuestManager.completed_quests = completed_quests.duplicate(true)
	QuestManager.current_state = current_state
	QuestManager.current_progress = current_progress

	# Don't restart a completed quest
	if current_quest_id != "":
		!QuestManager.completed_quests.has(current_quest_id)
		QuestManager.start_quest(current_quest_id)
		QuestManager.current_progress = current_progress
		QuestManager.current_state = current_state
	else:
		QuestManager.current_quest = null
