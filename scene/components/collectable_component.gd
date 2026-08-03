class_name CollectableComponent
extends Area2D

@export var collectable_name: String


#func _on_body_entered(body: Node2D) -> void:
	#if body is Player: 
		#InventoryManager.add_collectable(collectable_name)
		#print("Collected:", collectable_name)
		#get_parent().queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		InventoryManager.add_collectable(collectable_name)
		
		print(InventoryManager.inventory)
		
		QuestManager.add_progress(collectable_name)

		PlayerProgressManager.award_crop_exp(collectable_name)
		
		var exp = PlayerProgressManager.crop_exp.get(collectable_name, 0)

		print("Collected:", collectable_name)
		get_parent().queue_free()
