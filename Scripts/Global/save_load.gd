extends Node

#const

const SAVE_DIR: String = "res://Saves/"
const SAVE_PATH: String = SAVE_DIR + "SaveGame.bin"

const LEVELS = {
	1: "res://Levels/Levelbuilding/tutorial_level.tscn",
	2: "res://Levels/Levelbuilding/sunflowers_level_v2.tscn",
	3: "res://Levels/Levelbuilding/anthills_level.tscn",
	4: "res://Levels/Levelbuilding/GiantTree_v2.tscn"
}


#Function's

func Save_Game(data):
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		print_debug(FileAccess.get_open_error())
		return
	
	for n in range(data.size()):
		file.store_16(data[n])


func HasSaveGame():
	return FileAccess.file_exists(SAVE_PATH)


func Load_Game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	if file == null:
		return
	if FileAccess.file_exists(SAVE_PATH) == true:
		var data = []
		while file.get_position() < file.get_length():
			data.append(file.get_16())
		
		return data
