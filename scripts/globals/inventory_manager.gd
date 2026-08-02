extends Node
var current_shop: Node2D = null
var inventory: Dictionary = {}
signal inventory_changed

# 1. ADDING (Same as before)
func add_collectable(collectable_name: String) -> void:
	var key = collectable_name.to_lower()
	inventory[key] = inventory.get(key, 0) + 1
	inventory_changed.emit()

# 2. SELLING (Your original logic)
# Use this when the player sells an item in the shop
func remove_collectable(collectable_name: String) -> void:
	var key = collectable_name.to_lower()
	if inventory.has(key) and inventory[key] > 0:
		inventory[key] -= 1
		if inventory[key] <= 0:
			inventory.erase(key)
	inventory_changed.emit()

# 3. QUEST CHECKER (New helper)
# Use this for quests to check if they have enough
func has_item(item_name: String, amount: int) -> bool:
	var key = item_name.to_lower()

	print("Inventory =", inventory)
	print("Checking =", key)
	print("Need =", amount)
	print("Have =", inventory.get(key, 0))

	return inventory.get(key, 0) >= amount 

# 4. QUEST CONSUMER (New helper)
# Use this to batch-remove items when turning in a quest
func remove_item_stack(item_name: String, amount: int) -> void:
	var key = item_name.to_lower()
	if inventory.has(key):
		inventory[key] -= amount
		if inventory[key] <= 0:
			inventory.erase(key)
	inventory_changed.emit()
