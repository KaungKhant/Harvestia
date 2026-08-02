extends Node

# ==========================================================
# Profile Save Manager
# Handles save files for each profile.
# Does NOT save game data.
# SaveGameManager is still responsible for saving/loading.
# ==========================================================

const SAVE_FILE_PATTERN := "save_%s_game_data.tres"

# ----------------------------------------------------------
# Returns the full save file path for a profile and level
# ----------------------------------------------------------
func get_save_path(profile_name:String, level_name:String) -> String:

	return ProfileManager.get_profile_path(profile_name) + SAVE_FILE_PATTERN % level_name


# ----------------------------------------------------------
# Checks if a profile has a save for this level
# ----------------------------------------------------------
func has_save(profile_name:String, level_name:String) -> bool:

	return FileAccess.file_exists(get_save_path(profile_name, level_name))


# ----------------------------------------------------------
# Checks if the CURRENT selected profile has a save
# ----------------------------------------------------------
func current_profile_has_save() -> bool:

	if !ProfileManager.has_profile():
		return false

	var folder := ProfileManager.get_save_folder()

	if !DirAccess.dir_exists_absolute(folder):
		return false

	var dir := DirAccess.open(folder)

	if dir == null:
		return false

	dir.list_dir_begin()

	while true:

		var file := dir.get_next()

		if file == "":
			break

		if dir.current_is_dir():
			continue

		if file.ends_with(".tres"):
			dir.list_dir_end()
			return true

	dir.list_dir_end()

	return false

# ----------------------------------------------------------
# Deletes every save file inside a profile folder
# ----------------------------------------------------------
func delete_profile_save(profile_name:String) -> void:

	var folder := ProfileManager.get_profile_path(profile_name)

	if !DirAccess.dir_exists_absolute(folder):
		return

	var dir := DirAccess.open(folder)

	if dir == null:
		return

	dir.list_dir_begin()

	while true:

		var file := dir.get_next()

		if file == "":
			break

		if dir.current_is_dir():
			continue

		dir.remove(file)

	dir.list_dir_end()


# ----------------------------------------------------------
# Starts a brand-new game for the current profile
# ----------------------------------------------------------
func start_new_game() -> void:

	if !ProfileManager.has_profile():
		return

	delete_profile_save(ProfileManager.get_profile())


# ----------------------------------------------------------
# Returns every save file inside a profile
# ----------------------------------------------------------
func get_save_files(profile_name:String) -> Array[String]:

	var files:Array[String] = []

	var folder := ProfileManager.get_profile_path(profile_name)

	if !DirAccess.dir_exists_absolute(folder):
		return files

	var dir := DirAccess.open(folder)

	if dir == null:
		return files

	dir.list_dir_begin()

	while true:

		var file := dir.get_next()

		if file == "":
			break

		if dir.current_is_dir():
			continue

		files.append(file)

	dir.list_dir_end()

	return files
