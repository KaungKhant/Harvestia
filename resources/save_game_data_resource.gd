class_name SaveGameDataResource
extends Resource

@export var save_data_nodes: Array[NodeDataResource] = []

@export var collected_items: Array[String] = []

# Quest
@export var current_quest_id: String = ""
@export var current_progress: int = 0
@export var current_state: int = 0
@export var completed_quests: Dictionary = {}

# Area
@export var unlocked_areas: Dictionary = {}

# Tools
@export var unlocked_tools: Array[int] = []
