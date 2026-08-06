class_name ShopDataResource
extends NodeDataResource

# Add any shop-specific states you need to preserve here
# (e.g., if you store dynamic shop inventories or specific locked states)

func _save_data(node: Node) -> void:
	super._save_data(node)
	var shop = node as Node2D
	if shop:
		# Save any shop variables here if needed
		pass

func _load_data(source_node: Node) -> void:
	var shop = source_node.get_node_or_null(node_path)
	if shop == null:
		return
	
	# Restore any shop variables here if needed
