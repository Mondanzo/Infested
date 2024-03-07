extends EnemyState

func _ready():
	super._ready()


func _physics_process(_delta):
	if Enemy.state["RUN"]:
		rage_run_to_player()


func rage_run_to_player():
	var direction = Enemy.get_last_direction()
	
	if Enemy.detect_player() == true:
		Enemy.velocity.x = Enemy.RageSpeed * direction
	else:
		slow_enemy()
		
	if Enemy.detect_wall() == true:
		slow_enemy()



func slow_enemy():
	if abs(Enemy.velocity.x) > 0.35:
		Enemy.velocity.x *= 0.95
	else:
		Enemy.velocity.x = 0
		Enemy.reset_all_states_except("CHASE")
