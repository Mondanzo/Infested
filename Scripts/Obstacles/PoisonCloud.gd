extends Area3D

@export var damage_dealing = 1.0
@export var lifetime = 5.0


func _ready():
	$Lifetime.start(lifetime)
	$Lifetime.connect("timeout", queue_free)


func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is Player:
			body.DealDamage(damage_dealing)
