extends RigidBody3D

@export var Damage = 5.0
@export var knockback = 17.0

func _on_body_entered(body):
	explode()


func explode():
	$AnimationPlayer.play("explode")
	for body in $bombArea.get_overlapping_bodies():
		if body.has_method("DealDamage"):
			body.DealDamage(Damage)
		
		if body.has_method("Punch"):
			body.Punch((body.global_position - global_position).normalized() * knockback, true)
