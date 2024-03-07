extends EnemyState


func _ready():
	super._ready()


func _physics_process(delta):
	if Enemy.state["STAGE_3"]:
		if Enemy.global_transform.origin.distance_to(Enemy.PointStage3.global_transform.origin) > 1:
			follow_target(delta, Enemy.PointStage3)
		else:
			update_attack_visibility()
			Enemy.velocity = Vector3.ZERO
			if Enemy.stage_3_init_started == false:
				$Init_Timer.start()
				Enemy.stage_3_init_started = true
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
	Enemy.velocity = Enemy.MoveSpeed * direction


func update_attack_visibility():
	var bool
	
	if Enemy.can_attack:
		Enemy.laser_node.set_process_mode(0)
		bool = true
	else:
		Enemy.laser_node.set_process_mode(4)
		bool = false
	for node in Enemy.laser_node.get_children():
		node.visible = bool   


func _on_init_timer_timeout():
	Enemy.can_attack = true
	$laser_timer.start()


func _on_laser_timer_timeout():
	Enemy.can_attack = false
	$cooldown_timer.start()
	$Spawn_Timer.start()

func _on_cooldown_timer_timeout():
	Enemy.can_attack = true
	$laser_timer.start()


func _on_spawn_timer_timeout():
	Enemy.spawn_summon_fly()
