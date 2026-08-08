extends Node


enum QuestState {
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

var quest_start_gold: int = 0
var gold_earned: int = 0


# =================================================
# READY
# =================================================

func _ready() -> void:
	InventoryManager.inventory_changed.connect(
		sync_progress_with_inventory
	)


# =================================================
# START QUEST DATA
# =================================================

func start_quest_data(quest: QuestData) -> void:
	print("======================")
	print("Starting Quest:", quest.quest_id)

	current_quest = quest
	current_state = QuestState.IN_PROGRESS
	current_progress = 0
	gold_earned = 0

	if quest.target_item.to_lower() == "gold":
		quest_start_gold = PlayerProgressManager.gold

	quest_started.emit(quest)

	# Immediately check Homecoming progress.
	if quest.quest_id == "homecoming":
		sync_progress_with_inventory()


# =================================================
# START QUEST BY ID
# =================================================

func start_quest(quest_id: String) -> void:
	# Don't restart the same active/completed quest.
	if current_quest != null:
		if current_quest.quest_id == quest_id \
		and current_state != QuestState.NOT_STARTED:
			return

	var quest_path := "res://scripts/resources/" + quest_id + ".tres"

	if !ResourceLoader.exists(quest_path):
		push_error("Quest not found: " + quest_path)
		return

	var quest := load(quest_path) as QuestData

	if quest == null:
		push_error("Failed to load quest: " + quest_path)
		return

	start_quest_data(quest)


# =================================================
# ADD NORMAL QUEST PROGRESS
# =================================================

func add_progress(item_name: String) -> void:
	if current_quest == null:
		return

	if current_state != QuestState.IN_PROGRESS \
	and current_state != QuestState.READY_TO_TURN_IN:
		return

	if item_name.to_lower() != current_quest.target_item.to_lower():
		return

	sync_progress_with_inventory()


# =================================================
# COMPLETE QUEST
# =================================================

func complete_quest() -> void:
	if current_quest == null:
		return

	current_state = QuestState.COMPLETED

	quest_completed.emit(current_quest)


# =================================================
# GET CURRENT DIALOGUE LABEL
# =================================================

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


# =================================================
# TRY TO COMPLETE QUEST
# =================================================

func try_complete_quest() -> bool:
	# Quest must be ready to turn in.
	if current_state != QuestState.READY_TO_TURN_IN:
		return false

	if current_quest == null:
		return false

	# Objective is not actually finished.
	if current_progress < current_quest.target_amount:
		return false


	# =================================================
	# GOLD QUEST CHECK
	# =================================================

	if current_quest.target_item.to_lower() == "gold":
		if gold_earned < current_quest.target_amount:
			return false


	# =================================================
	# NORMAL INVENTORY QUEST CHECK
	# =================================================

	# Homecoming has its own resource-consumption system.
	if current_quest.target_item.to_lower() != "gold" \
	and current_quest.quest_id != "homecoming":

		if !InventoryManager.has_item(
			current_quest.target_item,
			current_quest.target_amount
		):
			return false


	# =================================================
	# CONSUME NORMAL QUEST ITEMS
	# =================================================

	if current_quest.consume_items \
	and current_quest.quest_id != "homecoming":

		InventoryManager.remove_item_stack(
			current_quest.target_item,
			current_quest.target_amount
		)


	# =================================================
	# GIVE REWARDS
	# =================================================

	PlayerProgressManager.add_exp(
		current_quest.reward_exp
	)

	PlayerProgressManager.add_gold(
		current_quest.reward_gold
	)


	# Keep reference before changing current state.
	var finished_quest := current_quest


	# =================================================
	# COMPLETE QUEST
	# =================================================

	current_state = QuestState.COMPLETED

	NotificationManager.show_quest_complete(
		finished_quest.quest_name,
		finished_quest.reward_exp,
		finished_quest.reward_gold
	)

	quest_completed.emit(finished_quest)

	completed_quests[finished_quest.quest_id] = true

	print("Completed:", finished_quest.quest_id)
	print("Next Quest:", finished_quest.next_quest)

	# We intentionally do NOT automatically start next_quest.
	#
	# if finished_quest.next_quest != "":
	# 	start_quest(finished_quest.next_quest)

	print("start_quest() called")

	return true


# =================================================
# READY TO TURN IN?
# =================================================

func is_ready_to_turn_in() -> bool:
	return current_state == QuestState.READY_TO_TURN_IN


# =================================================
# CHECK QUEST COMPLETION
# =================================================

func is_quest_completed(quest_id: String) -> bool:
	return completed_quests.get(quest_id, false)


# =================================================
# MARK READY TO TURN IN
# =================================================

func mark_ready_to_turn_in() -> void:
	if current_quest == null:
		return

	if current_state != QuestState.IN_PROGRESS:
		return

	current_progress = current_quest.target_amount
	current_state = QuestState.READY_TO_TURN_IN

	NotificationManager.show_objective(
		"Return to " + current_quest.quest_giver + "."
	)

	quest_updated.emit(
		current_progress,
		current_quest.target_amount
	)


# =================================================
# SYNC QUEST PROGRESS WITH INVENTORY
# =================================================

func sync_progress_with_inventory() -> void:
	if current_quest == null:
		return

	if current_state != QuestState.IN_PROGRESS \
	and current_state != QuestState.READY_TO_TURN_IN:
		return

	if current_quest.target_amount <= 0:
		return


	var target_item := current_quest.target_item.to_lower()
	var current_amount: int = 0


	# =================================================
	# HOMECOMING QUEST
	# =================================================

	if current_quest.quest_id == "homecoming":

		if HomecomingManager.is_complete():
			current_amount = current_quest.target_amount
		else:
			current_amount = 0


	# =================================================
	# GOLD QUEST
	# =================================================

	elif target_item == "gold":

		current_amount = gold_earned


	# =================================================
	# NORMAL INVENTORY QUEST
	# =================================================

	else:

		current_amount = InventoryManager.inventory.get(
			target_item,
			0
		)


	# =================================================
	# UPDATE PROGRESS
	# =================================================

	current_progress = min(
		current_amount,
		current_quest.target_amount
	)


	# =================================================
	# UPDATE QUEST STATE
	# =================================================

	if current_progress >= current_quest.target_amount:

		if current_state != QuestState.READY_TO_TURN_IN:

			current_state = QuestState.READY_TO_TURN_IN

			NotificationManager.show_objective(
				"Return to " + current_quest.quest_giver + "."
			)

	else:

		if current_state == QuestState.READY_TO_TURN_IN:

			current_state = QuestState.IN_PROGRESS


	# =================================================
	# UPDATE QUEST UI
	# =================================================

	quest_updated.emit(
		current_progress,
		current_quest.target_amount
	)


# =================================================
# ADD GOLD PROGRESS
# =================================================

func add_gold_progress(amount: int) -> void:
	if current_quest == null:
		return

	if current_quest.target_item.to_lower() != "gold":
		return

	print("----------------")
	print("Received:", amount)
	print("Before:", gold_earned)

	gold_earned += amount

	print("After:", gold_earned)

	current_progress = min(
		gold_earned,
		current_quest.target_amount
	)

	print("Current Progress:", current_progress)

	if current_progress >= current_quest.target_amount:

		if current_state != QuestState.READY_TO_TURN_IN:

			current_state = QuestState.READY_TO_TURN_IN

			NotificationManager.show_objective(
				"Return to " + current_quest.quest_giver + "."
			)

	quest_updated.emit(
		current_progress,
		current_quest.target_amount
	)
