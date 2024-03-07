extends Area3D

@export var tracking_enabled = true

@export_category("Cursor Tracking Settings")
@export_enum("Nearest", "Furthest", "Random") var sorting_to_use := 0
@export var check_with_raycast = false
@export var exclude_missed_points = true
@export_range(1, 10, 1, "hide_slider", "or_greater") var items_to_track = 1

var hit_objects = []


class CursorHitInfo:
	var hit_object = null
	var distance = 0.0
	var position = Vector3.ZERO
	var normal = Vector3.ZERO
	var valid_point = true


func HasHits():
	return len(hit_objects) > 0


func hit_sort(a: CursorHitInfo, b: CursorHitInfo):
	match sorting_to_use:
		0:
			return a.distance < b.distance
		1:
			return a.distance > b.distance
		2:
			return randf() <= 0.5


func validate_node(node: Node3D):
	var hit_data = CursorHitInfo.new()
	hit_data.position = node.global_position
	hit_data.distance = node.global_position.distance_to(global_position)
	if check_with_raycast:
		$NodeValidator.target_position = node.global_position * transform
		$NodeValidator.force_raycast_update()
		hit_data.valid_point = $NodeValidator.get_collider() == node
		hit_data.normal = $NodeValidator.get_collision_normal()
	return hit_data


func determine_nodes():
	if has_overlapping_bodies():
		var potential_hits = []
		for body in get_overlapping_bodies():
			var hit = validate_node(body)
			
			if exclude_missed_points and hit.valid_point:
				potential_hits.append(hit)
			else:
				potential_hits.append(hit)

		if sorting_to_use == 3:
			potential_hits.shuffle()
		else:
			potential_hits.sort_custom(hit_sort)
	
		hit_objects = potential_hits.slice(0, items_to_track)
	else:
		hit_objects = []


func _physics_process(_delta):
	determine_nodes()
