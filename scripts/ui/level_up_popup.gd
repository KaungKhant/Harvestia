extends CanvasLayer

@onready var level_label = $CenterContainer/PanelContainer/VBoxContainer/LevelLabel

func _ready():
	visible = false
	PlayerProgressManager.player_level_up.connect(show_level_up)


func show_level_up(level: int):
	level_label.text = "Level " + str(level)

	visible = true

	await get_tree().create_timer(2.0).timeout

	visible = false
