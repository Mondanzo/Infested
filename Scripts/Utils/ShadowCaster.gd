extends RayCast3D

func _process(delta):
	if is_colliding():
		$ShadowDecal.global_position = get_collision_point();
		$ShadowDecal.visible = true
	else:
		$ShadowDecal.visible = false
