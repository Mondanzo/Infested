extends Node3D
class_name TrackCursor

@export var tracking_enabled = true

@export_category("Cursor Tracking Settings")
@export_enum("TRACK_NEAREST", "TRACK_FURTHEST") var distance_to_track := 0
@export var snap_to_okay := true
@export var validate_function := func(_pos, _rot, _normal, _distance):
	return true


var cursor_colliding = false :
	set(value):
		if cursor_colliding != value:
			if value:
				emit_signal("on_hit", hit_info.valid_point)
			else:
				emit_signal("on_no_hit")
		cursor_colliding = value


var hit_info = CursorHitInfo.new()

signal on_hit(is_okay: bool)
signal on_no_hit


class CursorHitInfo:
	var hit_object = null
	var distance = 0.0
	var position = Vector3.ZERO
	var rotation = Vector3.ZERO
	var normal = Vector3.ZERO
	var valid_point = false


func _physics_process(_delta):
	$CursorHitPoint.global_position = hit_info.position
	$CursorHitPoint.global_rotation = hit_info.rotation
	
	if tracking_enabled:
		var pos3d = get_camera_cursor()
		if pos3d == null:
			return
		update_cursor_point(pos3d)
	else:
		cursor_colliding = false


func SetCustomValidate(validate_function: Callable):
	self.validate_function = validate_function


func sort_distances(a, b):
	match distance_to_track:
		0:
			return a["distance"] < b["distance"]
		1:
			return a["distance"] > b["distance"]


func get_camera_cursor():
	var raycast_camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var original = raycast_camera.project_ray_origin(mouse_pos)
	var normal = raycast_camera.project_ray_normal(mouse_pos)
	var dropPlane = Plane(0, 0, 1, owner.global_position.z)
	var pos3d = dropPlane.intersects_ray(original, normal)
	return pos3d


func update_cursor_point(cursor_pos):
	$CursorRaycaster.global_position = cursor_pos # $CursorRaycaster.global_position.lerp(cursor_pos, 0.1)
	#prints(cursor_pos, $CursorRaycaster.global_position)
	var distances = []
	
	for r in range(360 / 1):
		$CursorRaycaster.global_rotation_degrees = Vector3(0, 0, r * 1)
		$CursorRaycaster.force_raycast_update()
		if $CursorRaycaster.is_colliding():
			var normal = $CursorRaycaster.get_collision_normal()
			var pos = $CursorRaycaster.get_collision_point()
			var rot = Vector3(0, 0, normal.signed_angle_to(Vector3.UP, Vector3.FORWARD))
			var distance = pos.distance_to(cursor_pos)
			var is_okay = validate_function.call(pos, rot, normal, distance)
			if snap_to_okay and not is_okay:
				continue
			var new_entry = CursorHitInfo.new()
			new_entry.hit_object = $CursorRaycaster.get_collider()
			new_entry.distance = distance
			new_entry.position = pos
			new_entry.rotation = rot
			new_entry.valid_point = is_okay
			distances.append(new_entry)
	
	if len(distances) > 0:
		distances.sort_custom(sort_distances)
		hit_info = distances.pop_front()
		
		
		# Must be last!
		cursor_colliding = true
	else:
		cursor_colliding = false
