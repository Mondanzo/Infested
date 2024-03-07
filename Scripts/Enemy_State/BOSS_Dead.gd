extends EnemyState


func _ready():
	super._ready()

func _physics_process(delta):
	if Enemy.state["DEAD"]:
		Enemy.reset_all_states_except_direct("DEAD")
		if !Enemy.is_on_floor():
			Enemy.apply_gravity(delta)
		else:
			await get_tree().create_timer(5.0).timeout
			Enemy.queue_free()
