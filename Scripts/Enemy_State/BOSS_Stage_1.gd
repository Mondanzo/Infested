extends EnemyState


func _ready():
	super._ready()


func _physics_process(delta):
	if Enemy.state["STAGE_1"]:
		follow_target(delta, Enemy.PathStage1)
		update_path_progress_with_speed(Enemy.PathStage1, delta, Enemy.MoveSpeed)
	if Enemy.state["DEAD"]:
		disable_all_timer()

###############################################################
###########################Functions###########################
###############################################################

func disable_all_timer():
	for timer in get_children():
		if timer is Timer:
			timer.stop()


func follow_target(delta,current_target):
	var direction = (current_target.global_transform.origin - Enemy.global_transform.origin).normalized()
	
	if direction.length() < 0.1:
		Enemy.velocity = Vector3.ZERO
	else:
		Enemy.velocity = Enemy.MoveSpeed * direction


func update_path_progress_with_speed(Path, delta, speed):
	Path.progress += Enemy.velocity.length() * delta
	

func _on_bomb_timer_timeout():
	if Enemy.state["STAGE_1"]:
		var random_time = randf_range(Enemy.BombMinTime, Enemy.BombMaxTime)
		Enemy.spawn_bomb()
		$bomb_Timer.wait_time = random_time
	
