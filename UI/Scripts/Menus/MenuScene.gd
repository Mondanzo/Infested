extends Menu

@export var start_menu = "MainMenu"

func _ready():
	$CameraRig.offset = Vector3(0, 0, 0)
	change_menu(start_menu)
	for child in $Menus.get_children():
		if child.has_method("set_root_menu"):
			child.set_root_menu(self)


func fancy_load(level, data = {}):
	$LevelTransition.next_level = level
	$LevelTransition.cause = $PlayerDataHolder
	$PlayerDataHolder.data = data
	$LevelTransition._on_body_entered($PlayerDataHolder)

func change_menu(menu):
	if menu == "LoadSave":
		var save_game = SaveLoad.Load_Game()
		var level = SaveLoad.LEVELS[save_game[0]]
		var playerData = {}
		if save_game.size() > 2:
			playerData["health"] = save_game[1]
			playerData["score"] = save_game[2]
		fancy_load(level, playerData)
		return
	if ResourceLoader.exists(menu):
		fancy_load(menu)
		return
	
	for child in $Menus.get_children():
		if child.name == menu:
			child.visible = true
			child.process_mode = Node.PROCESS_MODE_INHERIT
			$CameraRig.node_to_track = child.get_node("Camera")
			if child.has_method("on_enter"):
				child.on_enter()
		else:
			child.visible = false
			child.process_mode = Node.PROCESS_MODE_DISABLED
