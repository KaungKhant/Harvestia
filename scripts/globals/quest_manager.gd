extends Node

enum QuestState{
	NOT_STARTED,
	IN_PROGRESS,
	READY_TO_TURN_IN,
	COMPLETED
}

signal quest_started(quest: QuestData)
signal quest_updated(current: int, target: int)
signal quest_completed(quest: QuestData)

var current_quest: QuestData = null
var current_state: QuestState = QuestState.NOT_STARTED
var current_progress: int = 0
var completed_quests: Dictionary = {}

func _ready() -> void:
	InventoryManager.inventory_changed.connect(sync_progress_with_inventory)

func start_quest_data(quest: QuestData) -> void:
	
	print("======================")
	print("Starting Quest:", quest.quest_id)
	current_quest = quest
	current_state = QuestState.IN_PROGRESS
	current_progress = 0

	quest_started.emit(quest)


func add_progress(item_name: String) -> void:
	if current_quest == null:
		return

	if current_state != QuestState.IN_PROGRESS and current_state != QuestState.READY_TO_TURN_IN:
		return

	if item_name.to_lower() != current_quest.target_item.to_lower():
		return

	sync_progress_with_inventory()

func complete_quest() -> void:
	current_state = QuestState.COMPLETED

	quest_completed.emit(current_quest)

func get_dialogue_label() -> String:
	if current_quest == null:
		return "start"

	match current_state:
		QuestState.NOT_STARTED:
			return "start"

		QuestState.IN_PROGRESS:
			return "progress"

		QuestState.READY_TO_TURN_IN:
			return "turn_in"

		QuestState.COMPLETED:
			return "completed"

	return "start"
	
func start_quest(quest_id: String) -> void:
	# Don't restart the same quest if it's already active
		# Don't restart a completed quest
	if current_quest != null:
		if current_quest.quest_id == quest_id and current_state != QuestState.NOT_STARTED:
			return

	var quest_path := "res://scripts/resources/" + quest_id + ".tres"

	if !ResourceLoader.exists(quest_path):
		push_error("Quest not found: " + quest_path)
		return

	var quest := load(quest_path) as QuestData

	start_quest_data(quest)
# Add this function to your existing quest_manager.gd
# Inside QuestManager.gd
func try_complete_quest() -> bool:
	# No active quest
	if current_state != QuestState.READY_TO_TURN_IN:
		return false

	if current_quest == null:
		return false

	# Objective not finished yet
	if current_progress < current_quest.target_amount:
		return true

	# Inventory check
	if !InventoryManager.has_item(current_quest.target_item, current_quest.target_amount):
		return true

	# Remove items only if this quest consumes them
	if current_quest.consume_items:
		InventoryManager.remove_item_stack(
		current_quest.target_item,
		current_quest.target_amount
	)
	print("Removing", current_quest.target_amount, current_quest.target_item)
	print(InventoryManager.inventory)
	print("After removal:")
	print(InventoryManager.inventory)

	# Give rewards
	PlayerProgressManager.add_exp(current_quest.reward_exp)
	PlayerProgressManager.add_gold(current_quest.reward_gold)

	# Keep a reference before changing anything
	var finished_quest := current_quest

	# Finish quest
	current_state = QuestState.COMPLETED

	NotificationManager.show_quest_complete(
	current_quest.quest_name,
	current_quest.reward_exp,
	current_quest.reward_gold
)

	quest_completed.emit(finished_quest)
	completed_quests[finished_quest.quest_id] = true
	
	print("Completed:", finished_quest.quest_id)
	print("Next Quest:", finished_quest.next_quest)
	
	# Start the next quest automatically
	#if finished_quest.next_quest != "":
		#start_quest(finished_quest.next_quest)
		
	print("start_quest() called")

	return true

func is_ready_to_turn_in() -> bool:
	return current_state == QuestState.READY_TO_TURN_IN
func is_quest_completed(quest_id: String) -> bool:
	return completed_quests.get(quest_id, false)

func sync_progress_with_inventory() -> void:
	if current_quest == null:
		return

	if current_state != QuestState.IN_PROGRESS and current_state != QuestState.READY_TO_TURN_IN:
		return

	var target_item := current_quest.target_item.to_lower()
	var inventory_amount: int = InventoryManager.inventory.get(target_item, 0)

	current_progress = min(inventory_amount, current_quest.target_amount)

	# FIRST update the quest state
	if current_progress >= current_quest.target_amount:
		if current_state != QuestState.READY_TO_TURN_IN:
			current_state = QuestState.READY_TO_TURN_IN
			NotificationManager.show_objective("Return to the Guide.")
	else:
		if current_state == QuestState.READY_TO_TURN_IN:
			current_state = QuestState.IN_PROGRESS

	# THEN tell the UI to refresh
	quest_updated.emit(
		current_progress,
		current_quest.target_amount
	)
