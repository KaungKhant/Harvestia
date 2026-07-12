extends CanvasLayer

@onready var level_label = $MarginContainer/PanelContainer/VBoxContainer/LevelLabel
@onready var exp_bar = $MarginContainer/PanelContainer/VBoxContainer/ExpBar
@onready var exp_label = $MarginContainer/PanelContainer/VBoxContainer/ExpLabel
@onready var gold_label = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/GoldLabel


func _ready():
    update_ui()

    PlayerProgressManager.exp_changed.connect(_on_exp_changed)
    PlayerProgressManager.level_changed.connect(_on_level_changed)
    PlayerProgressManager.gold_changed.connect(_on_gold_changed)


func update_ui():
    level_label.text = "Level: %d" % PlayerProgressManager.player_level

    exp_bar.max_value = PlayerProgressManager.required_exp
    exp_bar.value = PlayerProgressManager.current_exp

    exp_label.text = "%d / %d EXP" % [
        PlayerProgressManager.current_exp,
        PlayerProgressManager.required_exp
    ]

    gold_label.text = str(PlayerProgressManager.gold)


func _on_exp_changed(current_exp, required_exp):
    exp_bar.max_value = required_exp
    exp_bar.value = current_exp
    exp_label.text = "%d / %d EXP" % [current_exp, required_exp]


func _on_level_changed(level):
    level_label.text = "Level: %d" % level


func _on_gold_changed(gold):
    gold_label.text = str(gold)
