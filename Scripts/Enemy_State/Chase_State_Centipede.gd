extends EnemyState

var rage_run_detector
var direction


func _ready():
	super._ready()


func _physics_process(_delta):
	if Enemy.state["CHASE"] and !Enemy.state["RUN"]:
		direction = Enemy.get_last_direction()
		follow_player()


func follow_player():	
	if Enemy.detect_wall() == true:
		slow_enemy()
	elif Enemy.detect_player() == false:
		Enemy.velocity.x = Enemy.MoveSpeed * direction
		
	elif Enemy.detect_player() == true:
		slow_enemy()
		if Enemy.velocity.x == 0:
			await Enemy.play_full_animation("Animation_CHARGE")
			Enemy.reset_all_states_except("RUN")


func slow_enemy():
	if abs(Enemy.velocity.x) > 0.1:
		Enemy.velocity.x *= 0.8
	else:
		Enemy.velocity.x = 0
