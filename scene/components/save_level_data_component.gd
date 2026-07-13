class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource

func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name

func save_node_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	print("--- STARTING SAVE_NODE_DATA ---")
	print("Found ", nodes.size(), " nodes in group 'save_data_component'")
	
	game_data_resource = SaveGameDataResource.new()
	
	if nodes != null:
		for node in nodes:
			# Changed from 'if node is SaveDataComponent:' to checking if it has the function
			if node.has_method("_save_data"):
				print("Processing node: ", node.get_parent().name)
				var save_data_resource: NodeDataResource = node._save_data()
				
				if save_data_resource == null:
					print("❌ WARNING: Node '", node.get_parent().name, "' returned NULL data resource.")
					continue
				
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)
				print("✅ Successfully appended data for: ", node.get_parent().name)
			

func save_game() -> void:
	print("--- START SAVE ---")

	game_data_resource = SaveGameDataResource.new()

	save_node_data()
	game_data_resource.collected_items = SaveGameManager.collected_items.duplicate()

	# Save quest
	if QuestManager.current_quest != null:
		game_data_resource.current_quest_id = QuestManager.current_quest.quest_id

	game_data_resource.current_progress = QuestManager.current_progress
	game_data_resource.current_state = QuestManager.current_state
	game_data_resource.completed_quests = QuestManager.completed_quests.duplicate(true)

	# Save tools
	game_data_resource.unlocked_tools = ToolManager.unlocked_tools.duplicate()

	# Create save directory if needed
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)

	var level_save_file_name := save_file_name % level_scene_name
	var full_path := save_game_data_path + level_save_file_name

	var result := ResourceSaver.save(game_data_resource, full_path)

	if result == OK:
		print("Game saved successfully.")
	else:
		print("Save failed. Error:", result)
func load_game() -> void:
	var level_save_file_name := save_file_name % level_scene_name
	var save_game_path := save_game_data_path + level_save_file_name

	if !FileAccess.file_exists(save_game_path):
		print("Save file not found.")
		return

	game_data_resource = ResourceLoader.load(save_game_path)
	QuestManager.completed_quests = game_data_resource.completed_quests
	QuestManager.current_progress = game_data_resource.current_progress
	QuestManager.current_state = game_data_resource.current_state
	if game_data_resource.current_quest_id != "":
		QuestManager.start_quest(game_data_resource.current_quest_id)
		QuestManager.current_progress = game_data_resource.current_progress
		QuestManager.current_state = game_data_resource.current_state
	ToolManager.unlocked_tools = game_data_resource.unlocked_tools.duplicate()
	for tool in ToolManager.unlocked_tools:
		ToolManager.enable_tool_button(tool)
	if game_data_resource == null:
		print("Failed to load save file.")
		return

	var current_scene := get_tree().current_scene
	if current_scene == null:
		current_scene = get_tree().root

	# Find CropFields
	var crop_fields := current_scene.find_child("CropFields", true, false)

	print("Loading ", game_data_resource.save_data_nodes.size(), " resources...")
	if crop_fields:
		for child in crop_fields.get_children():
			child.queue_free()

	for resource in game_data_resource.save_data_nodes:

		# -------- Dynamic Crops --------
		if resource is CropDataResource:

			var crop_resource := resource as CropDataResource

			if crop_resource.scene_file_path == "":
				continue

			var crop_scene := load(crop_resource.scene_file_path)

			if crop_scene == null:
				print("Failed to load: ", crop_resource.scene_file_path)
				continue

			var crop = crop_scene.instantiate()

			if crop_fields:
				crop_fields.add_child(crop)
			else:
				current_scene.add_child(crop)

			crop_resource._load_data(crop)

			print("Loaded crop:", crop_resource.scene_file_path)

		# -------- Static objects --------
		elif resource is NodeDataResource:

			resource._load_data(current_scene)
