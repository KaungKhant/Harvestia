extends Node

signal exp_changed(current_exp: int, required_exp: int)
signal level_changed(level: int)
signal gold_changed(gold: int)
signal player_level_up(level: int)

var player_level: int = 1
var current_exp: int = 0
var required_exp: int = 10
var gold: int = 0

var crop_exp = {
	"corn": 10,
	"tomato": 15,
	"log" : 1,
	"stone": 2
}


func add_exp(amount: int) -> void:
	current_exp += amount

	while current_exp >= required_exp:
		current_exp -= required_exp
		player_level += 1

		# Increase EXP requirement by 50%
		required_exp = int(required_exp * 1.5)

		level_changed.emit(player_level)
		player_level_up.emit(player_level)
		
		NotificationManager.show_level(player_level)

	exp_changed.emit(current_exp, required_exp)


func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)


func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold)
		return true

	return false

func award_crop_exp(crop_name: String) -> void:
	if crop_exp.has(crop_name):
		add_exp(crop_exp[crop_name])
