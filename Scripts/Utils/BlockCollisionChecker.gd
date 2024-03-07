@tool
extends Node3D

@export var is_colliding: bool:
	get:
		return IsSpaceOccupied(global_position, global_rotation)

@export var shape_collider : Shape3D
@export_flags_3d_physics var collision_mask := 0b10000000


func _physics_process(_delta):
	is_colliding = IsSpaceOccupied(global_position, global_rotation)


func IsSpaceOccupied(test_position, test_euler_rotation):
	if shape_collider == null:
		return false
	
	var params = PhysicsShapeQueryParameters3D.new()
	params.shape = shape_collider
	params.collision_mask = collision_mask
	
	# Determine Transform to test in. Need to rotate the vector to support steep surfaces
	params.transform = Transform3D(
		Basis.from_euler(test_euler_rotation),
		test_position + Vector3(0, shape_collider.size.y / 2, 0)
			.rotated(Vector3.FORWARD, test_euler_rotation.z)
		)
	var colliders = get_world_3d().direct_space_state.intersect_shape(params)
	return len(colliders) > 0
