extends Node

var notification_ui: CanvasLayer = null

func register(ui: CanvasLayer) -> void:
	notification_ui = ui


func show(title: String, message: String = "", duration: float = 1.5) -> void:
	if notification_ui:
		notification_ui.show_notification(title, message, duration)
	else:
		push_warning("Notification UI is not registered.")


func show_gold(gold: int) -> void:
	show(
		"💰 Gold Received!",
		"+" + str(gold) + " Gold"
	)


func show_level(level: int) -> void:
	show(
		"⭐ Level Up!",
		"You reached Level " + str(level)
	)


func show_tool(tool_name: String) -> void:
	show(
		"🔓 New Tool Unlocked!",
		tool_name
	)
	
func show_seed(seed_name: String) -> void:
	show(
		"🌱 New Seed Unlocked!",
		seed_name
	)


func show_area(area_name: String) -> void:
	show(
		"🌉 New Area Unlocked!",
		area_name
	)


func show_quest_complete(quest_name: String, reward_exp: int, reward_gold: int) -> void:
	var message := quest_name

	if reward_exp > 0:
		message += "\n⭐ +" + str(reward_exp) + " EXP"

	if reward_gold > 0:
		message += "\n💰 +" + str(reward_gold) + " Gold"

	show(
		"✅ Quest Complete!",
		message,
		4.0
	)


func show_objective(message: String) -> void:
	show(
		"📖 Objective Complete!",
		message
	)
