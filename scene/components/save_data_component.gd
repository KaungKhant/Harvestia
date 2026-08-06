class_name SaveDataComponent
extends Node

@export var save_data_resource: NodeDataResource

func _ready() -> void:
	add_to_group("save_data_component")

func _save_data() -> NodeDataResource:
	if save_data_resource == null:
		return null

	print("SaveDataComponent parent:", get_parent().name)
	print("Parent script:", get_parent().get_script())

	var resource = save_data_resource.duplicate(true)

	resource._save_data(get_parent())

	return resource
