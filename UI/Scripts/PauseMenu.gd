extends Menu

@export_file("*.tscn") var menu_scene = "res://UI/Menus/MenuScene.tscn"
@export var start_menu = "MainMenu"


func change_menu(menu):
	for m in %Menus.get_children():
		if m.name == menu:
			m.visible = true
			if m.has_method("on_enter"):
				m.on_enter()
			if m.has_method("set_root_menu"):
				m.set_root_menu(self)
		else:
			m.visible = false


func on_enter():
	change_menu(start_menu)


func _on_btn_continue_pressed():
	Game.set_paused(false)


func _on_btn_options_pressed():
	change_menu("Options")


func _on_btn_back_to_menu_pressed():
	Game.return_to_menu()


func _on_pause_layer_visibility_changed():
	if owner.visible:
		on_enter()
