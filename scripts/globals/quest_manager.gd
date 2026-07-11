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


func start_quest_data(quest: QuestData) -> void:
	current_quest = quest
	current_state = QuestState.IN_PROGRESS
	current_progress = 0

	quest_started.emit(quest)


func add_progress(item_name: String) -> void:
	if current_state != QuestState.IN_PROGRESS:
		return

	if current_quest == null:
		return

	if item_name != current_quest.target_item:
		return

	current_progress += 1

	# Clamp progress
	if current_progress > current_quest.target_amount:
		current_progress = current_quest.target_amount

	# Always update the tracker
	quest_updated.emit(current_progress, current_quest.target_amount)

	# Objective completed
	if current_progress >= current_quest.target_amount and current_state == QuestState.IN_PROGRESS:
		current_state = QuestState.READY_TO_TURN_IN

		NotificationManager.show("📖 Objective Complete!\nReturn to the Guide.")


func complete_quest() -> void:
	current_state = QuestState.COMPLETED

	quest_completed.emit(current_quest)

func get_dialogue_label() -> String:
	if current_quest == null:
		return "start"

	match current_state:

		QuestState.NOT_STARTED:
			return current_quest.start_dialogue

		QuestState.IN_PROGRESS:
			return current_quest.progress_dialogue

		QuestState.READY_TO_TURN_IN:
			return "turn_in"

		QuestState.COMPLETED:
			return current_quest.complete_dialogue

	return "start"
	
func start_quest(quest_id: String) -> void:
	# Don't restart the same quest if it's already active
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

	# Remove items from inventory
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

	# Finish quest
	current_state = QuestState.COMPLETED

	NotificationManager.show("Quest Complete!")

	quest_completed.emit(current_quest)

	return true

func is_ready_to_turn_in() -> bool:
	return current_state == QuestState.READY_TO_TURN_IN
