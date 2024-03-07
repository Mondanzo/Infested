extends EnemyState

var direction: Vector3
var return_direction = Vector3(1, 0.4, 0)

func _ready():
	super._ready()


func _physics_process(delta):
	look_raycast_to_player()
	if Enemy.state["PICK"]:
		if is_player_visible():
			pick_player_attack()
		else:
			Enemy.reset_all_states_except("CHASE")

func pick_player_attack():
	var target_position = Target.global_transform.origin + Vector3(0, 2, 0)
	
	if !Enemy.is_target_reached:
		direction = (target_position - Enemy.global_transform.origin).normalized()
		Enemy.velocity = Enemy.RageSpeed * direction
	
		if Enemy.global_transform.origin.distance_to(target_position) < 2.0:
			Enemy.is_target_reached = true
			var new_velocity = Enemy.RageSpeed * return_direction.normalized()
			new_velocity.x = abs(new_velocity.x) * sign(Enemy.velocity.x)
			Enemy.velocity = new_velocity

			
	if Enemy.is_target_reached:
		if Enemy.global_transform.origin.distance_to(target_position) > 15.0:
			Enemy.velocity = Vector3.ZERO
			Enemy.is_target_reached = false
			Enemy.reset_all_states_except("CHASE")
			

func is_player_visible():
	return Enemy.raycast_target.get_collider() == Target

func look_raycast_to_player():
	var target_position = Target.global_transform.origin + Vector3(0, 2, 0)
	Enemy.raycast_target.look_at(target_position, Vector3.UP)
