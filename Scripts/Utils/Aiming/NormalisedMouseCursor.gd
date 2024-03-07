extends Node3D

@export var offset = 50.0

var direction = Vector3.ZERO


func get_camera_cursor():
	var raycast_camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var original = raycast_camera.project_ray_origin(mouse_pos)
	var normal = raycast_camera.project_ray_normal(mouse_pos)
	var dropPlane = Plane(0, 0, 1, owner.global_position.z)
	var pos3d = dropPlane.intersects_ray(original, normal)
	return pos3d


func _physics_process(_delta):
	var target_pos = get_camera_cursor()
	direction = (target_pos - get_parent().global_position).normalized()
	global_position = get_parent().global_position + direction * offset
	global_rotation.angle_to(direction)
	
