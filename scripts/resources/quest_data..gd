class_name QuestData
extends Resource

@export var quest_id : String
@export var quest_name : String
@export_multiline var description : String

@export var target_item : String
@export var target_amount : int

@export var reward_exp : int
@export var reward_gold : int

@export var start_dialogue : String
@export var progress_dialogue : String
@export var complete_dialogue : String

@export var next_quest : String
