class_name SaveGameDataResource
extends Resource

@export var save_data_nodes: Array[NodeDataResource] = []

@export var collected_items: Array[String] = []

# Quest
@export var current_quest_id := ""
@export var current_progress := 0
@export var current_state := 0
@export var completed_quests: Dictionary = {}

# Tools
@export var unlocked_tools: Array[int] = []
