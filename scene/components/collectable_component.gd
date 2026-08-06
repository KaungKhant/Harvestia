class_name CollectableComponent
extends Area2D

@export var collectable_name: String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:

		InventoryManager.add_collectable(collectable_name)
		QuestManager.add_progress(collectable_name)
		PlayerProgressManager.award_crop_exp(collectable_name)

		var harvest = get_parent()
		var save_component = harvest.get_node_or_null("SaveDataComponent")
		
		if save_component and save_component.save_data_resource is HarvestDataResource:
			# Mark the resource as removed so if it ever gets evaluated, it knows it's gone
			(save_component.save_data_resource as HarvestDataResource).is_removed = true
			save_component.remove_from_group("save_data_component")
			save_component.queue_free()

		harvest.queue_free()
