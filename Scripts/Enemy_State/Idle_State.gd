extends EnemyState


func _ready():
	super._ready()


func _physics_process(_delta):
	if Enemy.state["IDLE"]:
		slow_enemy()

func slow_enemy():
	if abs(Enemy.velocity.x) > 0.1:
		Enemy.velocity.x *= 0.95
	else:
		Enemy.velocity.x = 0
