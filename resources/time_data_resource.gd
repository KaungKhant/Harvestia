class_name TimeDataResource
extends NodeDataResource

@export var saved_day: int
@export var saved_hour: int
@export var saved_minute: int
@export var saved_time: float

func _save_data(_node: Node) -> void:
	super._save_data(_node)

	if DayAndNightCycleManager:
		saved_time = DayAndNightCycleManager.time


func _load_data(source_node: Node) -> void:
	if DayAndNightCycleManager == null:
		return

	DayAndNightCycleManager.time = saved_time
	DayAndNightCycleManager.recalculate_time()

	var panel = source_node.get_node_or_null(node_path)
	if panel == null:
		panel = source_node.get_tree().root.get_node_or_null(node_path)

	if panel != null:
		if panel.has_method("update_time_ui"):
			panel.update_time_ui()
		elif panel.has_method("update_ui"):
			panel.update_ui()
