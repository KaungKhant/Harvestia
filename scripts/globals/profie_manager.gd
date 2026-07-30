extends Node

const PROFILE_ROOT = "user://profiles/"

var current_profile : String = "Profile1"

func set_profile(profile_name:String):
	current_profile = profile_name

	var dir = PROFILE_ROOT + current_profile + "/"

	if !DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)

func get_save_folder():
	return PROFILE_ROOT + current_profile + "/"
