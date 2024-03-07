extends Node
class_name LifeEntity

@export var life = 0

func DealDamage(Damage):
	life -= Damage
	if life <= 0:
		queue_free()
