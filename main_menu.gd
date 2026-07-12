extends Control

func _ready():
    pass

func _on_play_pressed() -> void:
    StageManager.change_stage(StageManager.MainWorld)
