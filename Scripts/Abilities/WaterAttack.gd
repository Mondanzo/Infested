extends BaseSkill


@export var projectile: PackedScene
@export var projectile_speed = 1
@export var max_cooldown = 3
@export var ability_cooldown = 1.2
@export var projectile_lifetime = 3.0

var cursor

var is_on_cooldown = false


func _ready():
	cursor = $AttackOffset/NormalisedMouseCursor


func start_cooldown(duration = ability_cooldown):
	is_on_cooldown = true
	$Cooldown.start(duration)


func Use(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			handle_ability()

func handle_ability():
	if not is_on_cooldown:
		start_cooldown(ability_cooldown)
		for i in range(max_cooldown):
			spawn_projectile(cursor.global_position, (cursor.global_position - $AttackOffset.global_position).normalized())
			await get_tree().create_timer(0.1).timeout


func spawn_projectile(start_pos, direction):
	var new_projectile = projectile.instantiate()
	ability_spawn_container.add_child(new_projectile)
	new_projectile.global_position = start_pos
	new_projectile.Setup(direction * projectile_speed, projectile_lifetime, user)


func MaxCooldown():
	return ability_cooldown


func CurrentCooldown():
	return $Cooldown.time_left


func _on_cooldown_timeout():
	is_on_cooldown = false
