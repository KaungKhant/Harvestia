extends Node

signal ceremony_ready_for_dialogue

var ceremony_started: bool = false
var rowan_leading_started: bool = false
var ending_instance: CanvasLayer = null

func _ready() -> void:
    print("HomecomingCeremonyManager is ready.")

    GameDialogueManager.start_homecoming_ceremony.connect(
        _on_homecoming_ceremony_started
    )
    
    GameDialogueManager.rowan_lead_player.connect(
        move_rowan_to_restored_house
    )
    
    GameDialogueManager.open_ending.connect(
        _open_ending
    )


func _on_homecoming_ceremony_started() -> void:
    print("================================")
    print("HOMECOMING CEREMONY REQUESTED")
    print("================================")

    ceremony_started = true

    # Wait for the current dialogue to completely finish.
    print("Waiting for homecoming dialogue to end...")

    print("================================")
    print("HOMECOMING DIALOGUE ENDED")
    print("STARTING CEREMONY SEQUENCE")
    print("================================")

    ceremony_started = false

    call_deferred("_start_ceremony_sequence")

func _start_ceremony_sequence() -> void:
    print("================================")
    print("STARTING CEREMONY SEQUENCE")
    print("================================")

    _find_gathering_points()

    print("ROWAN MOVING...")
    await move_rowan_to_gathering_point()

    print("ELDER MOVING...")
    await move_elder_to_gathering_point()

    print("SHOPKEEPER MOVING...")
    await move_shopkeeper_to_gathering_point()

    print("RANGER MOVING...")
    await move_ranger_to_gathering_point()

    print("CHICKEN OWNER MOVING...")
    await move_chicken_owner_to_gathering_point()

    print("COW OWNER MOVING...")
    await move_cow_owner_to_gathering_point()

    print("================================")
    print("ALL NPCs HAVE ARRIVED")
    print("================================")
    
    ceremony_ready_for_dialogue.emit()
    call_deferred("_start_ceremony_dialogue")


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

    var rowan := current_scene.get_node_or_null(
		"EndingRowan"
    )

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

    await tween.finished

    print("Rowan reached RowanPoint.")


func move_elder_to_gathering_point() -> void:
    var current_scene := get_tree().current_scene

    if current_scene == null:
        print("ERROR: Current scene is NULL.")
        return

    var elder := current_scene.get_node_or_null(
		"village_elder"
    )

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

    await tween.finished

    print("Elder reached ElderPoint.")


func move_shopkeeper_to_gathering_point() -> void:
    var current_scene := get_tree().current_scene

    if current_scene == null:
        print("ERROR: Current scene is NULL.")
        return

    var shopkeeper := current_scene.get_node_or_null(
		"shopkeeper"
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

    await tween.finished

    print("Shopkeeper reached ShopkeeperPoint.")


func move_ranger_to_gathering_point() -> void:
    var current_scene := get_tree().current_scene

    if current_scene == null:
        print("ERROR: Current scene is NULL.")
        return

    var ranger := current_scene.get_node_or_null(
		"forest_ranger"
    )

    if ranger == null:
        print("ERROR: forest_ranger NOT FOUND.")
        return

    var points := current_scene.get_node_or_null(
		"HomecomingPoints"
    )

    if points == null:
        print("ERROR: HomecomingPoints NOT FOUND.")
        return

    var ranger_point := points.get_node_or_null(
		"RangerPoint"
    )

    if ranger_point == null:
        print("ERROR: RangerPoint NOT FOUND.")
        return

    var path := points.get_node_or_null(
		"RangerPath"
    )

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

    await tween.finished

    print("Ranger reached RangerPoint.")


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

    await tween.finished

    print("Chicken Owner reached ChickenOwnerPoint.")


func move_cow_owner_to_gathering_point() -> void:
    var current_scene := get_tree().current_scene

    if current_scene == null:
        print("ERROR: Current scene is NULL.")
        return

    var cow_owner := current_scene.find_child(
        "cow_barn_owner",
        true,
        false
    )

    if cow_owner == null:
        print("ERROR: cow_barn_owner NOT FOUND.")
        return

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

    await tween.finished

    print("Cow Owner reached CowOwnerPoint.")

func _start_ceremony_dialogue() -> void:
    print("================================")
    print("STARTING HOMECOMING CEREMONY DIALOGUE")
    print("================================")

    var dialogue_resource = load(
		"res://Dialog/Guide/homecoming.dialogue"
    )

    if dialogue_resource == null:
        print("ERROR: homecoming.dialogue NOT FOUND.")
        return

    DialogueManager.show_dialogue_balloon(
        dialogue_resource,
		"completed"
    )

func move_rowan_to_restored_house() -> void:
    if rowan_leading_started:
        print("Rowan leading sequence already completed. Ignoring duplicate call.")
        return

    rowan_leading_started = true
    
    var current_scene := get_tree().current_scene

    if current_scene == null:
        print("ERROR: Current scene is NULL.")
        return

    var rowan := current_scene.get_node_or_null("EndingRowan")

    if rowan == null:
        print("ERROR: EndingRowan NOT FOUND.")
        return

    var points := current_scene.get_node_or_null("HomecomingPoints")

    if points == null:
        print("ERROR: HomecomingPoints NOT FOUND.")
        return

    var restored_house_point := points.get_node_or_null(
		"RestoredHousePoint"
    )

    if restored_house_point == null:
        print("ERROR: RestoredHousePoint NOT FOUND.")
        return

    print("================================")
    print("ROWAN LEADING PLAYER TO RESTORED HOUSE")
    print("================================")
    print("Rowan starting position:", rowan.global_position)
    print("Restored house point:", restored_house_point.global_position)

    var tween := create_tween()

    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(
        rowan,
        "global_position",
        restored_house_point.global_position,
        2.0
    )

    await tween.finished

    print("================================")
    print("ROWAN REACHED RESTORED HOUSE")
    print("================================")

    await move_player_to_house()

    print("================================")
    print("PLAYER REACHED RESTORED HOUSE")
    print("================================")
    
    # Restore the house now that Rowan and the player have arrived.
    restore_home()


    await get_tree().create_timer(0.5).timeout

    start_final_homecoming_dialogue()
    
func move_player_to_house() -> void:
    var current_scene := get_tree().current_scene

    if current_scene == null:
        print("ERROR: Current scene is NULL.")
        return

    var player := current_scene.get_node_or_null("Player")

    if player == null:
        print("ERROR: Player NOT FOUND.")
        return

    var points := current_scene.get_node_or_null(
		"HomecomingPoints"
    )

    if points == null:
        print("ERROR: HomecomingPoints NOT FOUND.")
        return

    var player_point := points.get_node_or_null(
		"PlayerHousePoint"
    )

    if player_point == null:
        print("ERROR: PlayerHousePoint NOT FOUND.")
        return

    print("================================")
    print("PLAYER STARTING CEREMONY MOVE")
    print("================================")
    print("Player starting position:", player.global_position)
    print("Player destination:", player_point.global_position)

    var tween := create_tween()

    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(
        player,
        "global_position",
        player_point.global_position,
        2.0
    )

    await tween.finished

    print("Player reached PlayerHousePoint.")
    
func restore_home() -> void:
    var current_scene := get_tree().current_scene

    if current_scene == null:
        print("ERROR: Current scene is NULL.")
        return

    var damaged_house := current_scene.find_child("QuestHome", true, false)
    var repaired_house := current_scene.find_child("QuestHomeRepaired", true, false)
    var house := current_scene.find_child("House", true, false)

    if damaged_house == null:
        print("ERROR: QuestHome NOT FOUND.")
        return

    if repaired_house == null:
        print("ERROR: QuestHomeRepaired NOT FOUND.")
        return

    if house == null:
        print("ERROR: House NOT FOUND.")
        return

    print("================================")
    print("RESTORING GRANDFATHER'S HOUSE")
    print("================================")

    # Remove damaged visual
    damaged_house.hide()

    # We don't need the duplicate repaired TileMap visual
    repaired_house.hide()

    # Show the actual enterable repaired House
    house.show()

    print("House restoration complete.")
    print("================================")

func start_final_homecoming_dialogue() -> void:
    print("================================")
    print("STARTING FINAL HOMECOMING DIALOGUE")
    print("================================")

    var dialogue_resource = load(
		"res://Dialog/Guide/homecoming.dialogue"
    )

    if dialogue_resource == null:
        print("ERROR: homecoming.dialogue NOT FOUND.")
        return

    DialogueManager.show_dialogue_balloon(
        dialogue_resource,
		"final_ending"
    )

func _open_ending() -> void:
    print("OPENING HOMECOMING ENDING")

    if is_instance_valid(ending_instance):
        return

    var ending_scene := preload(
		"res://scene/ending/Ending.tscn"
    )

    ending_instance = ending_scene.instantiate() as CanvasLayer

    if ending_instance == null:
        print("ERROR: Could not create Ending scene.")
        return

    get_tree().current_scene.add_child(ending_instance)

    get_tree().paused = true

    print("ENDING OPENED")
