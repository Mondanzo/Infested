@tool
extends PathFollow3D

enum DIRECTION {
	FORWARDS = 1,
	BACKWARDS = -1
}

@export var direction = DIRECTION.FORWARDS
@export var speed = 2.0
@export var min_speed: float = 0.2
@export var rotation_limits: Vector3 = Vector3.UP

@export_range(0.0, 1.0, 0.01) var slowdown_threshhold = 0.2

var current_speed
var previous_position = Vector3.ZERO

func _ready():
	current_speed = speed
	progress_ratio = clamp(progress_ratio, 0.0, 1.0)


func adjust_rotation(delta):
	if rotation_mode != PathFollow3D.ROTATION_NONE:
		return
	
	if global_position.x == previous_position.x and global_position.z == previous_position.z:
		previous_position = global_position
		return
	
	var current_direction = (global_position - previous_position).normalized()
	var prev_rot = $bumblebee/bumblebee_armature.global_transform.basis.get_rotation_quaternion()
	
	$bumblebee/bumblebee_armature.look_at($bumblebee/bumblebee_armature.global_transform.origin - current_direction, Vector3.UP)
	$bumblebee/bumblebee_armature.global_rotation = $bumblebee/bumblebee_armature.global_transform.basis.get_rotation_quaternion().slerp(prev_rot, 0.9).get_euler() * rotation_limits
	previous_position = global_position


func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	var speed_ratio = 1.0
	
#	prints(progress_ratio, slowdown_threshhold, 1.0 - slowdown_threshhold)
	
	if progress_ratio <= slowdown_threshhold:
		speed_ratio = progress_ratio / slowdown_threshhold
		pass
	elif progress_ratio >= 1.0 - slowdown_threshhold:
		speed_ratio = (1.0 - progress_ratio) / slowdown_threshhold
	else:
		speed_ratio = 1.0
	
	current_speed = lerp(min_speed, speed, speed_ratio)
	
	progress += current_speed * direction * delta
	adjust_rotation(delta)
	if loop:
		return
	if progress_ratio >= 1.0:
		direction = -1
	elif progress_ratio <= 0.0:
		direction = 1
