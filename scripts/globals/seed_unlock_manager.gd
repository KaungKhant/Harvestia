extends Node

signal seed_unlocked(seed_name: String)

var unlocked_seeds: Dictionary = {
	"corn_seeds": true,
	"tomato_seeds": false,
	"carrot_seeds": false,
	"pumpkin_seeds": false
}


func is_seed_unlocked(seed_name: String) -> bool:
	return unlocked_seeds.get(seed_name, false)


func unlock_seed(seed_name: String) -> void:
	if not unlocked_seeds.has(seed_name):
		return

	if unlocked_seeds[seed_name]:
		return

	unlocked_seeds[seed_name] = true
	seed_unlocked.emit(seed_name)

	print("Seed unlocked:", seed_name)
