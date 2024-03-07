extends Area3D

@export var knockback = Vector2(30.0, 10.0)
@export var relative_knockback = true
@export var Damage = 1.0


func _physics_process(delta):
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			attack_node(body)


func get_knockback(knockback_position: Vector3):
	var direction = clampi((knockback_position.x - global_position.x) * 100, -1, 1)
	return Vector3(direction * knockback.x, knockback.y, 0)


func attack_node(body: Node3D):
	if body.has_method("DealDamage"):
		body.DealDamage(Damage)

	if body.has_method("Punch"):
		var knockbacks = Vector3(knockback.x, knockback.y, 0)
		if relative_knockback:
			knockbacks = get_knockback(body.global_position)
		body.Punch(knockbacks, true)
