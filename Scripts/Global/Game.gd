extends Node


enum GameState {
	MENU,
	INGAME,
	PAUSED,
	GAMEOVER,
	LOADING
}

@export_file("*.tscn") var menu_scene = "res://UI/Menus/MenuScene.tscn"

@onready var root = get_tree().get_root()

var current_state = GameState.MENU
var changing_scene = false
var scene_data = {}
var current_rig
var current_player
var local_current_scene

signal transition_entered
signal transition_exited
signal level_loaded

func set_current_rig(rig):
	current_rig = rig


func SetPlayer(player):
	current_player = player


func getPlayer():
	return current_player


func get_current_rig():
	return current_rig


func _input(event):
	if current_state == GameState.INGAME:
		if event.is_action_pressed("pause"):
			set_paused(!get_tree().paused)


func set_paused(paused):
	get_tree().paused = paused
	$PauseMenu.visible = paused
	current_state = GameState.PAUSED if paused else GameState.INGAME


func get_current_scene():
	if get_tree().current_scene == null:
		return local_current_scene
	return get_tree().current_scene


func set_current_scene(scene, data):
	if scene != null:
		var instantiated_scene = scene.instantiate()
		get_tree().set_current_scene(instantiated_scene)
		local_current_scene = instantiated_scene
		if instantiated_scene.has_method("Setup"):
			instantiated_scene.Setup(data)
		root.add_child(instantiated_scene)
		emit_signal("level_loaded")



func transition_enter():
	$TransitionScreen.enter()


func transition_exit():
	$TransitionScreen.exit()


func load_scene(scene):
	current_state = GameState.LOADING
	ResourceLoader.load_threaded_request(scene, "", false, ResourceLoader.CACHE_MODE_IGNORE)
	while ResourceLoader.load_threaded_get_status(scene) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	return ResourceLoader.load_threaded_get(scene)
		

func change_scene(scene, data = {}):
	if changing_scene:
		return false
	changing_scene = true
	transition_enter()
	await $TransitionScreen.enter_finished
	root.get_child(-1).queue_free()
	scene_data = data
	current_rig = null
	var result = await load_scene(scene)
	set_current_scene(result, scene_data)
	transition_exit()
	await $TransitionScreen.exit_finished
	changing_scene = false


func restart_level():
	transition_enter()
	await $TransitionScreen.enter_finished
	current_rig = null
	get_tree().reload_current_scene()
	get_tree().paused = false
	var scene = get_tree().current_scene
	if scene.has_method("Setup"):
		scene.Setup(scene_data)
	transition_exit()
	await $TransitionScreen.exit_finished


func game_over():
	current_state = GameState.GAMEOVER
	get_tree().paused = true
	$GameOver/AnimationPlayer.play("enter")
	$GameOver.visible = true


func get_overlay_screen():
	return $Overlays


func return_to_menu():
	var old_scene = get_tree().current_scene
	if old_scene != null:
		if old_scene.has_method("OnReturnToMenu"):
			old_scene.OnReturnToMenu()
	change_scene(menu_scene)
	Game.set_paused(false)


func _on_transition_screen_enter_finished():
	emit_signal("transition_entered")


func _on_transition_screen_exit_finished():
	emit_signal("transition_exited")
