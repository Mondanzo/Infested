extends EnemyState

var init_started = false

func _ready():
	super._ready()


func _physics_process(delta):
	if Enemy.state["STAGE_2"]:
		if !Enemy.stand_mode:
			follow_target(delta, Enemy.PathStage2)
			update_path_progress_with_speed(Enemy.PathStage2, delta, Enemy.MoveSpeed)
		else:
			Enemy.velocity = Vector3.ZERO
			
		if init_started == false:
			$Init_Timer.start()
			init_started = true
		
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


func _on_stand_timer_timeout():
	Enemy.stand_mode = false
	$Spawn_Timer.start()
	

func _on_spawn_timer_timeout():
	Enemy.stand_mode = true
	Enemy.spawn_wingflap_area()
	$Stand_Timer.start()
	var random_time = randf_range(Enemy.WingflapMinTime, Enemy.WingflapMaxTime)
	$Spawn_Timer.wait_time = random_time

func _on_init_timer_timeout():
	$Spawn_Timer.start()


func _on_bomb_timer_timeout():
	if Enemy.state["STAGE_2"] and !Enemy.stand_mode:
		var random_time = randf_range(Enemy.BombMinTime, Enemy.BombMaxTime)
		Enemy.spawn_bomb()
		$bomb_Timer.wait_time = random_time
