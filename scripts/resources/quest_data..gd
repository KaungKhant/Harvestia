class_name QuestData
extends Resource

@export var quest_id : String
@export var quest_name : String
@export_multiline var description : String

@export var target_item : String
@export var quest_icon : String
@export var target_amount : int

@export var reward_exp : int
@export var reward_gold : int

@export var dialogue_file : DialogueResource

@export var next_quest : String

@export var consume_items : bool = true
