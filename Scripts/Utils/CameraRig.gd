extends Node3D

@export var node_to_track: Node3D
@export var track_rotation = true
@export_range(0, 1, 0.01) var smooth_value = 0.1
@export_group("Screenshake")
@export var screenshake_enabled = true
@export var noise: FastNoiseLite
@export_range(0, 1, 0.01) var shakeAmount = 0.0
@export var shakeStrength = 5

var screenShaker = 1
var offset = Vector3.ZERO
@onready var original_rotation = rotation_degrees
@onready var original_position = $Camera3D.position

var noises = []

func _ready():
	randomize()
	offset = $Camera3D.position
	noise.seed = randi()
	Game.set_current_rig(self)


func toggle_overlays(enabled):
	$OverlaysRenderer.visible = enabled


func set_offset(new_offset):
	offset = new_offset


func _process(delta):
	if node_to_track != null:
		global_position = global_position.lerp(node_to_track.global_position, smooth_value)
		if track_rotation:
			global_rotation = global_rotation.lerp(node_to_track.global_rotation, smooth_value)
	$Camera3D.position = $Camera3D.position.lerp(offset, smooth_value)	
	
	if screenshake_enabled:
		if node_to_track and "trauma" in node_to_track:
			shakeAmount = pow(node_to_track.trauma, 2)
	
		screenShaker += 1
	
		var shakerX = noise.get_noise_3d(screenShaker, 0, 0)
		var shakerY = noise.get_noise_3d(0, screenShaker, 0)
		var shakerZ = noise.get_noise_3d(0, 0, screenShaker)
	
		rotation_degrees.x = lerpf(original_rotation.x, (original_rotation.x + shakerX * shakeStrength), shakeAmount)
		rotation_degrees.y = lerpf(original_rotation.y, (original_rotation.y + shakerY * shakeStrength), shakeAmount)
		rotation_degrees.z = lerpf(original_rotation.z, (original_rotation.z + shakerZ * shakeStrength), shakeAmount)
		$Camera3D.position.x = lerpf(offset.x, (offset.x + shakerX * shakeStrength), shakeAmount)
		$Camera3D.position.y = lerpf(offset.y, (offset.y + shakerY * shakeStrength), shakeAmount)
		
	%Camera3DOverlays.global_position = $Camera3D.global_position
	%Camera3DOverlays.global_rotation = $Camera3D.global_rotation
