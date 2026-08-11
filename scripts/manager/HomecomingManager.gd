extends Node
signal donation_completed_signal

const ENDING_ROWAN_SCENE := preload(
	"res://scene/characters/guide/EndingRowan.tscn"
)

var ending_rowan: Node2D = null
var donation_completed: bool = false

# -------------------------------------------------
# Homecoming Resource Requirements
# -------------------------------------------------

var required_resources: Dictionary = {
	"corn": 1,
	"tomato": 1,
	"carrot": 1,
	"pumpkin": 2,
	"egg": 1,
	"milk": 1,
	"log": 1,
	"stone": 1,
	"gold": 1
}


# -------------------------------------------------
# Ready
# -------------------------------------------------

func _ready() -> void:
	print("HomecomingManager is ready.")

	QuestManager.quest_started.connect(
		_on_quest_started
	)


# -------------------------------------------------
# Quest Started
# -------------------------------------------------

func _on_quest_started(quest: QuestData) -> void:
	print(
		"HomecomingManager received quest:",
		quest.quest_id
	)

	if quest.quest_id != "homecoming":
		return

	call_deferred("_spawn_ending_rowan")


# -------------------------------------------------
# Spawn Ending Rowan
# -------------------------------------------------

func _spawn_ending_rowan() -> void:
	print("================================")
	print("Homecoming: spawn function called.")

	# Prevent duplicate Rowan
	if is_instance_valid(ending_rowan):
		print("STOP: EndingRowan already exists.")
		return

	print("1. No existing EndingRowan.")

	# Get current scene
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("STOP: Current scene is NULL.")
		return

	print("2. Current scene:", current_scene.name)

	# Find spawn marker
	var spawn_marker := current_scene.get_node_or_null(
		"EndingRowanSpawn"
	) as Marker2D

	if spawn_marker == null:
		print("STOP: EndingRowanSpawn NOT FOUND.")
		return

	print("3. EndingRowanSpawn found.")
	print(
		"Spawn position:",
		spawn_marker.global_position
	)

	# Hide normal Rowan
	var guide := current_scene.get_node_or_null("guide")

	if guide == null:
		print("WARNING: guide node NOT FOUND.")
	else:
		print("4. Guide found. Hiding normal Rowan.")
		guide.hide()
		guide.set_process_unhandled_input(false)

	# Create Ending Rowan
	print("5. Instantiating EndingRowan.")

	ending_rowan = ENDING_ROWAN_SCENE.instantiate()

	if ending_rowan == null:
		print("STOP: Failed to instantiate EndingRowan.")
		return

	print("6. EndingRowan instantiated.")

	current_scene.add_child(ending_rowan)

	print("7. EndingRowan added to scene.")

	ending_rowan.global_position = spawn_marker.global_position

	print(
		"8. EndingRowan positioned at:",
		ending_rowan.global_position
	)

	print("Homecoming: EndingRowan spawned successfully.")
	print("================================")


# -------------------------------------------------
# Get Current Resource Progress
# -------------------------------------------------

func get_progress() -> Dictionary:
	var progress: Dictionary = {}

	progress["corn"] = InventoryManager.inventory.get(
		"corn",
		0
	)

	progress["tomato"] = InventoryManager.inventory.get(
		"tomato",
		0
	)

	progress["carrot"] = InventoryManager.inventory.get(
		"carrot",
		0
	)

	progress["pumpkin"] = InventoryManager.inventory.get(
		"pumpkin",
		0
	)

	progress["egg"] = InventoryManager.inventory.get(
		"egg",
		0
	)

	progress["milk"] = InventoryManager.inventory.get(
		"milk",
		0
	)

	progress["log"] = InventoryManager.inventory.get(
		"log",
		0
	)

	progress["stone"] = InventoryManager.inventory.get(
		"stone",
		0
	)

	progress["gold"] = PlayerProgressManager.gold

	return progress


# -------------------------------------------------
# Get Required Resources
# -------------------------------------------------

func get_required() -> Dictionary:
	return required_resources.duplicate()


# -------------------------------------------------
# Check Homecoming Completion
# -------------------------------------------------

func is_complete() -> bool:
	if donation_completed:
		print("Homecoming is COMPLETE: donation already completed.")
		return true

	var progress := get_progress()

	print("========== HOMECOMING CHECK ==========")

	for resource_name in required_resources:
		var current_amount: int = progress.get(resource_name, 0)
		var required_amount: int = required_resources[resource_name]

		print(
			resource_name,
			": ",
			current_amount,
			" / ",
			required_amount
		)

		if current_amount < required_amount:
			print(
				"NOT COMPLETE because of: ",
				resource_name
			)
			print("======================================")
			return false

	print("HOMECOMING IS COMPLETE!")
	print("======================================")

	return true


# -------------------------------------------------
# Donate All Homecoming Resources
# -------------------------------------------------

func donate_materials() -> bool:
	if donation_completed:
		print("Homecoming: Donation already completed.")
		return false
	
	if !is_complete():
		return false

	# Remove crops and animal products
	InventoryManager.remove_item_stack(
		"corn",
		required_resources["corn"]
	)

	InventoryManager.remove_item_stack(
		"tomato",
		required_resources["tomato"]
	)

	InventoryManager.remove_item_stack(
		"carrot",
		required_resources["carrot"]
	)

	InventoryManager.remove_item_stack(
		"pumpkin",
		required_resources["pumpkin"]
	)

	InventoryManager.remove_item_stack(
		"egg",
		required_resources["egg"]
	)

	InventoryManager.remove_item_stack(
		"milk",
		required_resources["milk"]
	)

	# Remove building materials
	InventoryManager.remove_item_stack(
		"log",
		required_resources["log"]
	)

	InventoryManager.remove_item_stack(
		"stone",
		required_resources["stone"]
	)

	# Remove gold safely
	if !PlayerProgressManager.spend_gold(
		required_resources["gold"]
	):
		return false

	# Remember that the final contribution has been made.
	donation_completed = true

	print("================================")
	print("Homecoming resources donated.")
	print("================================")

	# Update QuestManager
	QuestManager.sync_progress_with_inventory()
	
	donation_completed_signal.emit()

	return true
