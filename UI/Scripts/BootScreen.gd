extends Control

@export_file("*.tscn") var menu_scene = "res://UI/Menus/MenuScene.tscn"
@export_file("*.tscn") var logo_parade = "res://UI/Objects/LogoParade.tscn"

var start_scene

func _ready():
	var parade = await Game.load_scene(logo_parade)
	var parade_instance = parade.instantiate()
	parade_instance.connect("logo_parade_finished", animation_finished)
	add_child(parade_instance)
	start_scene = await Game.load_scene(menu_scene)

func animation_finished():
	while start_scene == null:
		await get_tree().process_frame
	Game.set_current_scene(start_scene, {})
	queue_free()
	
