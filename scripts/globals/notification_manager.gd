extends Node

var notification_ui: CanvasLayer = null

func register(ui: CanvasLayer) -> void:
    notification_ui = ui


func show(title: String, message: String = "", duration: float = 2.0) -> void:
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
        "🪓 New Tool Unlocked!",
        tool_name
    )


func show_area(area_name: String) -> void:
    show(
        "🌉 New Area Unlocked!",
        area_name
    )


func show_quest_complete(quest_name: String) -> void:
    show(
        "✅ Quest Complete!",
        quest_name
    )


func show_objective(message: String) -> void:
    show(
        "📖 Objective Complete!",
        message
    )
