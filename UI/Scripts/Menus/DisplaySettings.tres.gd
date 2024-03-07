extends Menu

var window_modes = [DisplayServer.WINDOW_MODE_WINDOWED, DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]

var is_ready = false

func _ready():
	load_settings()
	is_ready = true


func load_settings():
	print("loading settings")
	_on_control_vsync_toggled(DisplayServer.window_get_vsync_mode() > 0)
	var display_mode = DisplayServer.window_get_mode()
	match display_mode:
		DisplayServer.WINDOW_MODE_WINDOWED:
			print("Windowed!")
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			print("Fullscreen!")
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			print("Fullscreen but exclusive!")
	%ControlWindowMode.button_pressed = (display_mode == DisplayServer.WINDOW_MODE_FULLSCREEN)


func on_enter():
	pass


func _on_control_window_mode_item_selected(button_pressed):
	if button_pressed:
		print("toggled on")
		%ControlWindowAnimation.play("toggle")
	else:
		print("toggled off")
		%ControlWindowAnimation.play_backwards("toggle")
	if not is_ready:
		return
	var mode_to_set = window_modes[1 if button_pressed else 0]
	prints("Changing Window mode to", mode_to_set)
	DisplayServer.window_set_mode(mode_to_set)


func _on_control_vsync_toggled(button_pressed):
	if button_pressed:
		print("toggled on")
		%ControlVsyncAnimation.play("toggle")
	else:
		print("toggled off")
		%ControlVsyncAnimation.play_backwards("toggle")
	
	if not is_ready:
		return
	prints("Chaning VSYCN to:", "On" if button_pressed else "Off")
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if button_pressed else DisplayServer.VSYNC_DISABLED)
