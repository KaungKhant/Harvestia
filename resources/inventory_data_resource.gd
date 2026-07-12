class_name InventoryDataResource
extends NodeDataResource

# 🟢 Change this to a Dictionary to match your InventoryManager setup perfectly!
@export var saved_inventory: Dictionary = {}

func _save_data(_node: Node) -> void:
    super._save_data(_node)
    
    # 🟢 Pull directly from your global Autoload manager
    if InventoryManager and InventoryManager.inventory != null:
        # Duplicate the dictionary to ensure we make a clean copy for the file
        saved_inventory = InventoryManager.inventory.duplicate()
    else:
        push_error("Save Error: InventoryManager autoload not found.")


func _load_data(source_node: Node) -> void:
    if InventoryManager == null:
        push_error("Load Error: InventoryManager autoload not found.")
        return
        
    # 🟢 Inject the saved data straight back into the global manager
    InventoryManager.inventory = saved_inventory.duplicate()
    
    # 🟢 Force the inventory manager to broadcast to the UI panel that data changed!
    if InventoryManager.has_signal("inventory_changed"):
        InventoryManager.inventory_changed.emit()
    else:
        # Fallback: If the signal isn't global, try to manually call the panel's update
        var panel = source_node.get_node_or_null(node_path)
        if panel == null:
            panel = source_node.get_tree().root.get_node_or_null(node_path)
            
        if panel != null and panel.has_method("on_inventory_changed"):
            panel.on_inventory_changed()
