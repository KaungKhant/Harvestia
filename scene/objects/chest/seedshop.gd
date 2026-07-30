extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")

@export var dialogue_start_command: String = "start_shop"

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $Chest
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool
var is_shop_open: bool

# ─── SHOP TRANSACTION VARIABLES ───
var temp_qty: int = 1
var temp_item_type: String = ""
var temp_price: int = 0
var temp_tool_enum: String = ""
var temp_prev_menu: String = ""

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	if is_shop_open:
		if animated_sprite_2d.sprite_frames.has_animation("chest_close"):
			animated_sprite_2d.play("chest_close")
	
	is_shop_open = false
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range and not is_shop_open:
		if event.is_action_pressed("show_dialogue"):
			interactable_label_component.hide()
			
			if animated_sprite_2d.sprite_frames.has_animation("chest_open"):
				animated_sprite_2d.play("chest_open")
				
			is_shop_open = true
			
			InventoryManager.current_shop = self
			
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(load("res://Dialog/Conversation/chest.dialogue"), dialogue_start_command)

### ─── BUYING SYSTEM ─── ###

func buy_seeds(seed_type: String, tool_enum_value: DataTypes.Tools, single_cost: int, amount: int) -> bool:
	# BUGS DEFENSE: Never allow 0 or negative quantities to process!
	if amount <= 0:
		print("Transaction rejected: Invalid quantity amount!")
		return false

	# SEED LOCK CHECK
	if not SeedUnlockManager.is_seed_unlocked(seed_type):
		print("Transaction rejected: ", seed_type, " is locked!")
		return false

	var total_cost = single_cost * amount

	if not PlayerProgressManager.spend_gold(total_cost):
		return false

	print("Buying:", amount, seed_type)

	if InventoryManager.inventory.has(seed_type):
		InventoryManager.inventory[seed_type] += amount
	else:
		InventoryManager.inventory[seed_type] = amount

	print("Inventory after buying:", InventoryManager.inventory)

	# Notify the quest system that seeds were purchased
	for i in amount:
		QuestManager.add_progress(seed_type)

	ToolManager.enable_tool.emit(tool_enum_value)
	InventoryManager.inventory_changed.emit()

	return true


### ─── SELLING SYSTEM ─── ###

func sell_item(item_type: String, item_earnings: int, amount: int) -> bool:
	# BUGS DEFENSE: Never allow 0 or negative quantities to process!
	if amount <= 0:
		print("Transaction rejected: Invalid quantity amount!")
		return false
		
	var inventory: Dictionary = InventoryManager.inventory
	
	# Check if player actually has enough items to sell
	if not inventory.has(item_type) or inventory[item_type] < amount:
		print("Not enough items to sell!")
		return false
		
	# Deduct the items
	inventory[item_type] -= amount
	
	# Give gold to the player
	var total_payout = item_earnings * amount
	PlayerProgressManager.add_gold(total_payout)
	
	# Tell your inventory UI panels to refresh immediately
	InventoryManager.inventory_changed.emit()
	return true
