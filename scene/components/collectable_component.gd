class_name CollectableComponent
extends Area2D

@export var collectable_name: String


#func _on_body_entered(body: Node2D) -> void:
	#if body is Player: 
		#InventoryManager.add_collectable(collectable_name)
		#print("Collected:", collectable_name)
		#get_parent().queue_free()

func _on_body_entered(body: Node2D) -> void:
<<<<<<< HEAD
	if body is Player:
		InventoryManager.add_collectable(collectable_name)
		
		print(InventoryManager.inventory)
		
		QuestManager.add_progress(collectable_name)

		PlayerProgressManager.award_crop_exp(collectable_name)
		
		var exp = PlayerProgressManager.crop_exp.get(collectable_name, 0)

		print("Collected:", collectable_name)
		get_parent().queue_free()
=======
    if body is Player:

        InventoryManager.add_collectable(collectable_name)
        QuestManager.add_progress(collectable_name)
        PlayerProgressManager.award_crop_exp(collectable_name)

        var harvest = get_parent()

        harvest.remove_from_group("save_data_component")

        var save_component = harvest.get_node_or_null("SaveDataComponent")
        if save_component:
            save_component.queue_free()

        harvest.queue_free()
>>>>>>> 14ffdd6bb963e1bf30349ef10a93dae7394d2eaf
