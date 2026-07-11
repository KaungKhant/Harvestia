extends CanvasLayer

@onready var message_label: Label = $CenterContainer/PanelContainer/MessageLabel

func _ready():
	visible = false

	# Register this UI with the NotificationManager
	NotificationManager.register(self)


func show_notification(message: String, duration: float = 2.0) -> void:
	message_label.text = message

	visible = true

	await get_tree().create_timer(duration).timeout

	visible = false
