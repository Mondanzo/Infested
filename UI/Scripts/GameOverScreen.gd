extends CanvasLayer

@export_file("*.tscn") var menu_scene = "res://UI/Menus/MenuScene.tscn"

func OnEnter():
	$AnimationPlayer.play("enter")


func _on_btn_restart_pressed():
	$AnimationPlayer.play("retry")
	Game.restart_level()
	await Game.transition_entered
	visible = false


func _on_btn_back_to_menu_pressed():
	Game.change_scene(menu_scene)
	await Game.transition_entered
	Game.set_paused(false)
	visible = false
