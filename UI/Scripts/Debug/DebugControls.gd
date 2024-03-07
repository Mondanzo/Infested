extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("debug_toggle_controls"):
		visible = !visible
		pass
