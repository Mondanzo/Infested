extends EnemyState

var can_attack = true
@export var attack_cooldown = 0

func _ready():
	super._ready()

func _physics_process(delta):
	attack_cooldown -= delta
	
	if attack_cooldown <= 0:
		can_attack = true
	
	if Enemy.state["ATTACK"]:
		if can_attack and Enemy.Target.has_method("DealDamage"):
			attack_cooldown = 1.5
			can_attack = false
