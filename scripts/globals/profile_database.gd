extends Node

const PROFILE_FILE := "user://profiles/profiles.json"

var profiles : Array[String] = []

func _ready():
	load_profiles()


func load_profiles():

	profiles.clear()

	if !FileAccess.file_exists(PROFILE_FILE):
		save_profiles()
		return

	var file = FileAccess.open(PROFILE_FILE, FileAccess.READ)

	if file == null:
		return

	var json = JSON.new()

	if json.parse(file.get_as_text()) != OK:
		file.close()
		return

	file.close()

	var data = json.data

	if data is Array:
		for p in data:
			profiles.append(str(p))


func save_profiles():

	var file = FileAccess.open(PROFILE_FILE, FileAccess.WRITE)

	file.store_string(JSON.stringify(profiles))

	file.close()


func create_profile(profile_name:String)->bool:

	profile_name = profile_name.strip_edges()

	if profile_name == "":
		return false

	if profiles.has(profile_name):
		return false

	profiles.append(profile_name)

	var folder = ProfileManager.get_profile_path(profile_name)

	if !DirAccess.dir_exists_absolute(folder):
		DirAccess.make_dir_recursive_absolute(folder)

	save_profiles()

	return true


func delete_profile(profile_name:String):

	if !profiles.has(profile_name):
		return

	# Delete save files
	var folder = ProfileManager.get_profile_path(profile_name)

	if DirAccess.dir_exists_absolute(folder):

		var dir = DirAccess.open(folder)

		if dir:

			dir.list_dir_begin()

			while true:

				var file = dir.get_next()

				if file == "":
					break

				if dir.current_is_dir():
					continue

				dir.remove(file)

			dir.list_dir_end()

		DirAccess.remove_absolute(folder)

	# Remove from profile list
	profiles.erase(profile_name)

	save_profiles()
func rename_profile(old_name:String,new_name:String)->bool:

	new_name = new_name.strip_edges()

	if new_name=="":
		return false

	if profiles.has(new_name):
		return false

	var index = profiles.find(old_name)

	if index==-1:
		return false

	var old_folder = ProfileManager.get_profile_path(old_name)

	var new_folder = ProfileManager.get_profile_path(new_name)

	DirAccess.rename_absolute(old_folder,new_folder)

	profiles[index]=new_name

	save_profiles()

	return true


func get_profiles()->Array[String]:

	return profiles.duplicate()


func profile_exists(profile_name:String)->bool:

	return profiles.has(profile_name)
