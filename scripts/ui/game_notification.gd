extends CanvasLayer

@onready var title_label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var message_label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MessageLabel

func _ready():
    visible = false

    NotificationManager.register(self)

    NotificationManager.register(self)

func show_notification(title: String, message: String = "", duration: float = 2.0) -> void:
    title_label.text = title
    message_label.text = message
    message_label.visible = message != ""

    visible = true

    await get_tree().create_timer(duration).timeout

    visible = false
