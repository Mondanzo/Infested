extends EnemyState


func _ready():
	super._ready()


func _physics_process(delta):
	if Enemy.state["IDLE"]:
		follow_target(delta)
		


func follow_target(delta):
	var direction = (Enemy.IDLE_Target.global_transform.origin - Enemy.global_transform.origin).normalized()
	Enemy.velocity = Enemy.MoveSpeed * direction
