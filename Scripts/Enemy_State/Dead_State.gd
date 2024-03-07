extends EnemyState


func _ready():
	super._ready()

func _physics_process(delta):
	if Enemy.state["DEAD"]:
		Enemy.velocity = Vector3.ZERO
		Enemy.collision_mask &= ~(1 << 2)
