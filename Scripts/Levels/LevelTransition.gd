extends Area3D

@export var cause: Node3D
@export_file("*.tscn") var next_level = ""


func set_player(player):
	cause = player


func _on_body_entered(body):
	if body != cause:
		return
	
	if not ResourceLoader.exists(next_level):
		print("Level doesn't exist.")
		return
	
	$Animator.play("transition")
	body.visible = false
	body.process_mode = Node.PROCESS_MODE_DISABLED
	
	var camera = Game.get_current_rig()
	
	camera.track_rotation = true
	camera.screenshake_enabled = false
	camera.set_offset(Vector3.ZERO)
	camera.node_to_track = $CameraTarget
	
	var data = {}
	
	if body.has_method("GetPlayerData"):
		data["playerData"] = body.GetPlayerData()
	
	await $Animator.animation_finished
	Game.change_scene(next_level, data)
