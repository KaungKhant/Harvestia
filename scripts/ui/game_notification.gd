extends CanvasLayer

@onready var title_label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var message_label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MessageLabel

var notification_queue: Array = []
var is_showing_notification: bool = false


func _ready() -> void:
	visible = false
	NotificationManager.register(self)


func show_notification(
	title: String,
	message: String = "",
	duration: float = 2.0
) -> void:
	# Add notification to the queue
	notification_queue.append({
		"title": title,
		"message": message,
		"duration": duration
	})

	# Start processing if nothing is currently showing
	if not is_showing_notification:
		_process_queue()


func _process_queue() -> void:
	if notification_queue.is_empty():
		is_showing_notification = false
		visible = false
		return

	is_showing_notification = true

	var notification = notification_queue.pop_front()

	title_label.text = notification["title"]
	message_label.text = notification["message"]
	message_label.visible = notification["message"] != ""

	visible = true

	await get_tree().create_timer(notification["duration"]).timeout

	visible = false

	# Small gap between notifications
	await get_tree().create_timer(0.1).timeout

	_process_queue()
