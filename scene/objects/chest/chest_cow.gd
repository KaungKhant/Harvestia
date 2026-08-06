extends Node2D

var balloon_scene = preload("res://Dialog/game_dialogue_balloon.tscn")
var milk_reward_scene = preload("res://scene/objects/milk.tscn")

@export var dialogue_start_command: String
@export var food_drop_height: int = 40
@export var reward_output_radius: int = 20

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var feed_component: FeedComponent = $FeedComponent
@onready var reward_marker: Marker2D = $RewardMarker
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool
var is_chest_open: bool


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals_cow)
	feed_component.food_received.connect(on_food_received)


func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true


func on_interactable_deactivated() -> void:
	if is_chest_open:
		animated_sprite_2d.play("chest_close")

	is_chest_open = false
	interactable_label_component.hide()
	in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):

			# Player must own the Cow Barn first.
			if !PlayerProgressManager.owns_cow_barn:
				interactable_label_component.hide()

				var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
				get_tree().current_scene.add_child(balloon)

				balloon.start(
					load("res://Dialog/Conversation/chest.dialogue"),
					"not_owner"
				)
				return

			# Open pasture box
			interactable_label_component.hide()
			animated_sprite_2d.play("chest_open")
			is_chest_open = true

			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(
				load("res://Dialog/Conversation/chest.dialogue"),
				dialogue_start_command
			)


func on_feed_the_animals_cow() -> void:
	if in_range:
		var inventory: Dictionary = InventoryManager.inventory

		# Need 2 corn to feed cows
		if inventory.get("corn", 0) >= 2:
			process_corn_to_milk()
		else:
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(
				load("res://Dialog/Conversation/chest.dialogue"),
				"not_enough_corn"
			)


func process_corn_to_milk() -> void:
	# Remove exactly 2 corn
	for i in range(2):
		InventoryManager.remove_collectable("corn")

	# Spawn exactly 2 milk
	for i in range(2):
		var reward_instance = milk_reward_scene.instantiate() as Node2D
		reward_instance.global_position = get_random_position_in_circle(
			reward_marker.global_position,
			reward_output_radius
		)
		get_tree().root.add_child(reward_instance)

		await get_tree().create_timer(0.1).timeout


func on_food_received(area: Area2D) -> void:
	pass


func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2i:
	var angle = randf() * TAU
	var distance_from_center = sqrt(randf()) * radius

	var x: int = center.x + distance_from_center * cos(angle)
	var y: int = center.y + distance_from_center * sin(angle)

	return Vector2i(x, y)
