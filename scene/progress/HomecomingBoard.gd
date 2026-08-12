extends CanvasLayer

@onready var corn = $PanelContainer/MarginContainer/VBoxContainer/CornLabel
@onready var tomato = $PanelContainer/MarginContainer/VBoxContainer/TomatoLabel
@onready var carrot = $PanelContainer/MarginContainer/VBoxContainer/CarrotLabel
@onready var pumpkin = $PanelContainer/MarginContainer/VBoxContainer/PumpkinLabel
@onready var egg = $PanelContainer/MarginContainer/VBoxContainer/EggLabel
@onready var milk = $PanelContainer/MarginContainer/VBoxContainer/MilkLabel
@onready var wood = $PanelContainer/MarginContainer/VBoxContainer/WoodLabel
@onready var stone = $PanelContainer/MarginContainer/VBoxContainer/StoneLabel
@onready var gold = $PanelContainer/MarginContainer/VBoxContainer/GoldLabel

@onready var donate_button = $PanelContainer/MarginContainer/VBoxContainer/DonateButton
@onready var close_button = $PanelContainer/MarginContainer/VBoxContainer/CloseButton


func _ready():
    hide()

    donate_button.pressed.connect(on_donate_pressed)
    close_button.pressed.connect(hide)


func open():
    show()
    refresh()


func refresh():

    var progress = HomecomingManager.get_progress()
    var required = HomecomingManager.get_required()

    corn.text = "🌽 Corn: %d / %d" % [progress["corn"], required["corn"]]
    tomato.text = "🍅 Tomato: %d / %d" % [progress["tomato"], required["tomato"]]
    carrot.text = "🥕 Carrot: %d / %d" % [progress["carrot"], required["carrot"]]
    pumpkin.text = "🎃 Pumpkin: %d / %d" % [progress["pumpkin"], required["pumpkin"]]
    egg.text = "🥚 Egg: %d / %d" % [progress["egg"], required["egg"]]
    milk.text = "🥛 Milk: %d / %d" % [progress["milk"], required["milk"]]
    wood.text = "🪵 Wood: %d / %d" % [progress["log"], required["log"]]
    stone.text = "🪨 Stone: %d / %d" % [progress["stone"], required["stone"]]
    gold.text = "🪙 Gold: %d / %d" % [progress["gold"], required["gold"]]

    donate_button.disabled = !HomecomingManager.is_complete()


func on_donate_pressed() -> void:
    print("========== DONATE PRESSED ==========")

    var success := HomecomingManager.donate_materials()

    print("Donation success: ", success)

    if success:
        hide()
        print("Homecoming Board hidden.")
