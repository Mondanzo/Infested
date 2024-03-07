extends Node3D

@onready var raycast = $RayCast3D
@onready var laser_mask = $CSGCombiner3D/CSGBox3D



func _process(delta):
	var object = raycast.get_collider()
	var hit_point = raycast.get_collision_point()
	
	if visible:
		if object != null:
			laser_mask.size.y = hit_point.distance_to(laser_mask.global_transform.origin) * 2
		else:
			laser_mask.size.y = 0.01

		if object is Player:
			object.DealDamage(2)
