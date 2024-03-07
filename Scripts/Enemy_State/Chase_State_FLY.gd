extends EnemyState

var direction


func _ready():
	super._ready()


func _physics_process(delta):
	if Enemy.state["CHASE"]:
		if check_if_player_detected():
			Enemy.velocity = Vector3.ZERO
			await get_tree().create_timer(1.5).timeout
			Enemy.reset_all_states_except("PICK")
			
		else:
			follow_player(delta)


func follow_player(delta):
	direction = (Target.global_transform.origin - Enemy.global_transform.origin).normalized()
	Enemy.velocity = Enemy.MoveSpeed * direction
	rotate_detector()


func check_if_player_detected():
	if Enemy.raycast_target.get_collider() == Target:
		Enemy.velocity = Vector3.ZERO
		return true
	else:
		return false

func rotate_detector():
	Enemy.raycast_target.look_at(Target.global_position, Vector3.UP)
