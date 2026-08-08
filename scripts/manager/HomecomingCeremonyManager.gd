extends Node


var ceremony_started: bool = false


func _ready() -> void:
	print("HomecomingCeremonyManager is ready.")

	GameDialogueManager.start_homecoming_ceremony.connect(
		_on_homecoming_ceremony_started
	)


func _on_homecoming_ceremony_started() -> void:
	print("================================")
	print("HOMECOMING CEREMONY STARTED")
	print("================================")

	ceremony_started = true

	call_deferred("_find_gathering_points")
	call_deferred("move_rowan_to_gathering_point")
	call_deferred("move_elder_to_gathering_point")
	call_deferred("move_shopkeeper_to_gathering_point")
	call_deferred("move_ranger_to_gathering_point")
	call_deferred("move_chicken_owner_to_gathering_point")
	call_deferred("move_cow_owner_to_gathering_point")


func _find_gathering_points() -> void:
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("ERROR: Current scene is NULL.")
		return

	print("Current scene:", current_scene.name)

	var points := current_scene.get_node_or_null(
		"HomecomingPoints"
	)

	if points == null:
		print("ERROR: HomecomingPoints NOT FOUND.")
		return

	print("HomecomingPoints found.")


	var restored_house_point := points.get_node_or_null(
		"RestoredHousePoint"
	)

	var elder_point := points.get_node_or_null(
		"ElderPoint"
	)

	var rowan_point := points.get_node_or_null(
		"RowanPoint"
	)

	var shopkeeper_point := points.get_node_or_null(
		"ShopkeeperPoint"
	)

	var ranger_point := points.get_node_or_null(
		"RangerPoint"
	)

	var chicken_owner_point := points.get_node_or_null(
		"ChickenOwnerPoint"
	)

	var cow_owner_point := points.get_node_or_null(
		"CowOwnerPoint"
	)


	print("--------------------------------")
	print("CHECKING CEREMONY POINTS")
	print("--------------------------------")


	if restored_house_point == null:
		print("ERROR: RestoredHousePoint NOT FOUND.")
	else:
		print(
			"RestoredHousePoint: ",
			restored_house_point.global_position
		)


	if elder_point == null:
		print("ERROR: ElderPoint NOT FOUND.")
	else:
		print(
			"ElderPoint: ",
			elder_point.global_position
		)


	if rowan_point == null:
		print("ERROR: RowanPoint NOT FOUND.")
	else:
		print(
			"RowanPoint: ",
			rowan_point.global_position
		)


	if shopkeeper_point == null:
		print("ERROR: ShopkeeperPoint NOT FOUND.")
	else:
		print(
			"ShopkeeperPoint: ",
			shopkeeper_point.global_position
		)


	if ranger_point == null:
		print("ERROR: RangerPoint NOT FOUND.")
	else:
		print(
			"RangerPoint: ",
			ranger_point.global_position
		)


	if chicken_owner_point == null:
		print("ERROR: ChickenOwnerPoint NOT FOUND.")
	else:
		print(
			"ChickenOwnerPoint: ",
			chicken_owner_point.global_position
		)


	if cow_owner_point == null:
		print("ERROR: CowOwnerPoint NOT FOUND.")
	else:
		print(
			"CowOwnerPoint: ",
			cow_owner_point.global_position
		)


	print("--------------------------------")
	print("Gathering point check complete.")
	print("================================")
	
func move_rowan_to_gathering_point() -> void:
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("ERROR: Current scene is NULL.")
		return

	var rowan := current_scene.get_node_or_null("EndingRowan")

	if rowan == null:
		print("ERROR: EndingRowan NOT FOUND.")
		return

	var points := current_scene.get_node_or_null(
		"HomecomingPoints"
	)

	if points == null:
		print("ERROR: HomecomingPoints NOT FOUND.")
		return

	var rowan_point := points.get_node_or_null(
		"RowanPoint"
	)

	if rowan_point == null:
		print("ERROR: RowanPoint NOT FOUND.")
		return

	print("================================")
	print("ROWAN STARTING CEREMONY MOVE")
	print("From:", rowan.global_position)
	print("To:", rowan_point.global_position)
	print("================================")

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		rowan,
		"global_position",
		rowan_point.global_position,
		2.0
	)

	tween.finished.connect(
		func() -> void:
			print("Rowan reached RowanPoint.")
	)

func move_elder_to_gathering_point() -> void:
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("ERROR: Current scene is NULL.")
		return

	var elder := current_scene.get_node_or_null("village_elder")

	if elder == null:
		print("ERROR: village_elder NOT FOUND.")
		return

	var points := current_scene.get_node_or_null(
		"HomecomingPoints"
	)

	if points == null:
		print("ERROR: HomecomingPoints NOT FOUND.")
		return

	var elder_point := points.get_node_or_null(
		"ElderPoint"
	)

	if elder_point == null:
		print("ERROR: ElderPoint NOT FOUND.")
		return

	print("================================")
	print("ELDER STARTING CEREMONY MOVE")
	print("From:", elder.global_position)
	print("To:", elder_point.global_position)
	print("================================")

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		elder,
		"global_position",
		elder_point.global_position,
		2.0
	)

	tween.finished.connect(
		func() -> void:
			print("Elder reached ElderPoint.")
	)

func move_shopkeeper_to_gathering_point() -> void:
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("ERROR: Current scene is NULL.")
		return

	var shopkeeper := current_scene.get_node_or_null(
		"SeedShop/Shopkeeper"
	)

	if shopkeeper == null:
		print("ERROR: SeedShop/Shopkeeper NOT FOUND.")
		return

	var points := current_scene.get_node_or_null(
		"HomecomingPoints"
	)

	if points == null:
		print("ERROR: HomecomingPoints NOT FOUND.")
		return

	var shopkeeper_point := points.get_node_or_null(
		"ShopkeeperPoint"
	)

	if shopkeeper_point == null:
		print("ERROR: ShopkeeperPoint NOT FOUND.")
		return

	var path := points.get_node_or_null(
		"ShopkeeperPath"
	)

	if path == null:
		print("ERROR: ShopkeeperPath NOT FOUND.")
		return

	var waypoint1 := path.get_node_or_null("Waypoint1")
	var waypoint2 := path.get_node_or_null("Waypoint2")
	var waypoint3 := path.get_node_or_null("Waypoint3")

	if waypoint1 == null or waypoint2 == null or waypoint3 == null:
		print("ERROR: Shopkeeper waypoints are missing.")
		return

	print("================================")
	print("SHOPKEEPER CEREMONY MOVE")
	print("Starting position:", shopkeeper.global_position)
	print("Waypoint 1:", waypoint1.global_position)
	print("Waypoint 2:", waypoint2.global_position)
	print("Waypoint 3:", waypoint3.global_position)
	print("Final point:", shopkeeper_point.global_position)
	print("================================")

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		shopkeeper,
		"global_position",
		waypoint1.global_position,
		1.5
	)

	tween.tween_property(
		shopkeeper,
		"global_position",
		waypoint2.global_position,
		1.5
	)

	tween.tween_property(
		shopkeeper,
		"global_position",
		waypoint3.global_position,
		1.5
	)

	tween.tween_property(
		shopkeeper,
		"global_position",
		shopkeeper_point.global_position,
		1.5
	)

	tween.finished.connect(
		func() -> void:
			print("Shopkeeper reached ShopkeeperPoint.")
	)
	
func move_ranger_to_gathering_point() -> void:
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("ERROR: Current scene is NULL.")
		return

	var ranger := current_scene.get_node_or_null("forest_ranger")

	if ranger == null:
		print("ERROR: forest_ranger NOT FOUND.")
		return

	var points := current_scene.get_node_or_null("HomecomingPoints")

	if points == null:
		print("ERROR: HomecomingPoints NOT FOUND.")
		return

	var ranger_point := points.get_node_or_null("RangerPoint")

	if ranger_point == null:
		print("ERROR: RangerPoint NOT FOUND.")
		return

	var path := points.get_node_or_null("RangerPath")

	if path == null:
		print("ERROR: RangerPath NOT FOUND.")
		return

	var waypoint1 := path.get_node_or_null("Waypoint1")
	var waypoint2 := path.get_node_or_null("Waypoint2")
	var waypoint3 := path.get_node_or_null("Waypoint3")

	if waypoint1 == null or waypoint2 == null or waypoint3 == null:
		print("ERROR: Ranger waypoints are missing.")
		return

	print("================================")
	print("RANGER CEREMONY MOVE")
	print("Starting position:", ranger.global_position)
	print("Waypoint 1:", waypoint1.global_position)
	print("Waypoint 2:", waypoint2.global_position)
	print("Waypoint 3:", waypoint3.global_position)
	print("Final point:", ranger_point.global_position)
	print("================================")

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		ranger,
		"global_position",
		waypoint1.global_position,
		1.5
	)

	tween.tween_property(
		ranger,
		"global_position",
		waypoint2.global_position,
		1.5
	)

	tween.tween_property(
		ranger,
		"global_position",
		waypoint3.global_position,
		1.5
	)

	tween.tween_property(
		ranger,
		"global_position",
		ranger_point.global_position,
		1.5
	)

	tween.finished.connect(
		func() -> void:
			print("Ranger reached RangerPoint.")
	)

func move_chicken_owner_to_gathering_point() -> void:
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("ERROR: Current scene is NULL.")
		return

	var chicken_owner := current_scene.get_node_or_null(
		"chicken_coop_owner"
	)

	if chicken_owner == null:
		print("ERROR: chicken_coop_owner NOT FOUND.")
		return

	var points := current_scene.get_node_or_null(
		"HomecomingPoints"
	)

	if points == null:
		print("ERROR: HomecomingPoints NOT FOUND.")
		return

	var chicken_owner_point := points.get_node_or_null(
		"ChickenOwnerPoint"
	)

	if chicken_owner_point == null:
		print("ERROR: ChickenOwnerPoint NOT FOUND.")
		return

	var path := points.get_node_or_null(
		"ChickenOwnerPath"
	)

	if path == null:
		print("ERROR: ChickenOwnerPath NOT FOUND.")
		return

	var waypoint1 := path.get_node_or_null("Waypoint1")
	var waypoint2 := path.get_node_or_null("Waypoint2")
	var waypoint3 := path.get_node_or_null("Waypoint3")

	if waypoint1 == null or waypoint2 == null or waypoint3 == null:
		print("ERROR: Chicken Owner waypoints are missing.")
		return

	print("================================")
	print("CHICKEN OWNER CEREMONY MOVE")
	print("Starting position:", chicken_owner.global_position)
	print("Waypoint 1:", waypoint1.global_position)
	print("Waypoint 2:", waypoint2.global_position)
	print("Waypoint 3:", waypoint3.global_position)
	print("Final point:", chicken_owner_point.global_position)
	print("================================")

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		chicken_owner,
		"global_position",
		waypoint1.global_position,
		1.5
	)

	tween.tween_property(
		chicken_owner,
		"global_position",
		waypoint2.global_position,
		1.5
	)

	tween.tween_property(
		chicken_owner,
		"global_position",
		waypoint3.global_position,
		1.5
	)

	tween.tween_property(
		chicken_owner,
		"global_position",
		chicken_owner_point.global_position,
		1.5
	)

	tween.finished.connect(
		func() -> void:
			print("Chicken Owner reached ChickenOwnerPoint.")
	)

func move_cow_owner_to_gathering_point() -> void:
	var current_scene := get_tree().current_scene

	if current_scene == null:
		print("ERROR: Current scene is NULL.")
		return

	print("================================")
	print("SEARCHING FOR COW BARN OWNER")
	print("Current scene:", current_scene.name)
	print("================================")

	var cow_owner := current_scene.find_child(
		"cow_barn_owner",
		true,
		false
	)

	if cow_owner == null:
		print("ERROR: cow_barn_owner NOT FOUND.")
		print("Searching all nodes for names containing 'cow':")

		var all_nodes := current_scene.find_children("*", "", true, false)

		for node in all_nodes:
			if "cow" in node.name.to_lower():
				print(
					"FOUND COW-RELATED NODE:",
					node.name,
					"| Type:",
					node.get_class()
				)

		return

	print("SUCCESS!")
	print("Cow Barn Owner found:", cow_owner.name)
	print("Cow Barn Owner position:", cow_owner.global_position)

	var points := current_scene.get_node_or_null(
		"HomecomingPoints"
	)

	if points == null:
		print("ERROR: HomecomingPoints NOT FOUND.")
		return

	var cow_owner_point := points.get_node_or_null(
		"CowOwnerPoint"
	)

	if cow_owner_point == null:
		print("ERROR: CowOwnerPoint NOT FOUND.")
		return

	var path := points.get_node_or_null(
		"CowOwnerPath"
	)

	if path == null:
		print("ERROR: CowOwnerPath NOT FOUND.")
		return

	var waypoint1 := path.get_node_or_null("Waypoint1")
	var waypoint2 := path.get_node_or_null("Waypoint2")
	var waypoint3 := path.get_node_or_null("Waypoint3")

	if waypoint1 == null or waypoint2 == null or waypoint3 == null:
		print("ERROR: Cow Owner waypoints are missing.")
		return

	print("================================")
	print("COW OWNER CEREMONY MOVE")
	print("Starting position:", cow_owner.global_position)
	print("Waypoint 1:", waypoint1.global_position)
	print("Waypoint 2:", waypoint2.global_position)
	print("Waypoint 3:", waypoint3.global_position)
	print("Final point:", cow_owner_point.global_position)
	print("================================")

	var tween := create_tween()

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		cow_owner,
		"global_position",
		waypoint1.global_position,
		1.5
	)

	tween.tween_property(
		cow_owner,
		"global_position",
		waypoint2.global_position,
		1.5
	)

	tween.tween_property(
		cow_owner,
		"global_position",
		waypoint3.global_position,
		1.5
	)

	tween.tween_property(
		cow_owner,
		"global_position",
		cow_owner_point.global_position,
		1.5
	)

	tween.finished.connect(
		func() -> void:
			print("Cow Owner reached CowOwnerPoint.")
	)
