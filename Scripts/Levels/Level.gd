extends Node

@export var level_index = -1
@export var player:Node3D
var current_data = {}

func Setup(data):
	current_data = data
	prepare(data)
	Game.current_state = Game.GameState.INGAME
	Game.set_paused(false)
	print(current_data)
	if "playerData" in current_data and player.has_method("SetPlayerData"):
		player.SetPlayerData(current_data["playerData"])
	Game.SetPlayer(player)

func prepare(_data):
	pass


func OnReturnToMenu():
	var save_data = [level_index]
	if "playerData" in current_data:
		save_data.append(current_data["playerData"]["health"])
		save_data.append(current_data["playerData"]["fragments"])
	SaveLoad.Save_Game(save_data)
