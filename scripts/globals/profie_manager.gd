extends Node

# ======================================================
# Profile Manager
# Keeps track of the currently selected profile.
# This script DOES NOT create or delete profiles.
# That will be handled by ProfileDatabase.gd.
# ======================================================

const PROFILE_ROOT := "user://profiles/"

var current_profile: String = ""

signal profile_changed(profile_name: String)

func _ready() -> void:
	# Make sure the profiles folder exists.
	if !DirAccess.dir_exists_absolute(PROFILE_ROOT):
		DirAccess.make_dir_recursive_absolute(PROFILE_ROOT)


func set_profile(profile_name: String) -> void:
	current_profile = profile_name

	var folder := get_save_folder()

	if !DirAccess.dir_exists_absolute(folder):
		DirAccess.make_dir_recursive_absolute(folder)

	profile_changed.emit(profile_name)


func clear_profile() -> void:
	current_profile = ""


func has_profile() -> bool:
	return current_profile != ""


func get_profile() -> String:
	return current_profile


func get_save_folder() -> String:
	if current_profile.is_empty():
		return PROFILE_ROOT

	return PROFILE_ROOT.path_join(current_profile) + "/"


func get_profile_path(profile_name:String) -> String:
	return PROFILE_ROOT.path_join(profile_name) + "/"
