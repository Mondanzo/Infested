extends BaseSkill

@export var Damage = 5
@export var punch_strength = 300
@export var stone_block: PackedScene
@export var angle = 75.0
@export var ability_cooldown = 3.0
@export var attack_cooldown = 0.2
@export var punch_velocity = Vector3(0.0, -500.0, 0)
@export var punch_degrees = 40.0
@export var enemies_to_attack = 1
@export_range(0, 1, 0.1) var max_steep = 0.4


var is_on_cooldown = false
var current_rock: Node3D = null


func _ready():
	grab_collider()


func grab_collider():
	var temp_block = stone_block.instantiate()
	$BlockCollisionChecker.shape_collider = temp_block.GetCollider()
	temp_block.queue_free()


func validate_cursor_location(pos: Vector3, normal: Vector3):
	if normal.length() == 0:
		return false
	
	var hit_rotation = normal.signed_angle_to(Vector3.UP, Vector3.FORWARD)
	
	if abs(hit_rotation) <= max_steep:
		return true
		if not $BlockCollisionChecker.IsSpaceOccupied(pos, Vector3(0, 0, hit_rotation)):
			return true
	return false


func Destroy():
	if not current_rock == null and is_instance_valid(current_rock):
		current_rock.Destroy()


func CurrentCooldown():
	return $EarthAbilityCooldown.time_left


func MaxCooldown():
	return ability_cooldown


func Use(event):
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT:
			handle_ability()


func handle_ability():
	if is_on_cooldown:
		return
	start_cooldown()
	if $CanSpawnBlock.is_colliding():
		var spawn_point = $CanSpawnBlock.get_collision_point()
		var spawn_normal = $CanSpawnBlock.get_collision_normal()
		if validate_cursor_location(spawn_point, spawn_normal):
			create_block(spawn_point, Vector3(0, 0, spawn_normal.signed_angle_to(Vector3.UP, Vector3.FORWARD)))


func destroy_old_block():
	if not current_rock == null and is_instance_valid(current_rock):
		current_rock.Destroy()


func create_block(pos: Vector3, rot: Vector3):
	destroy_old_block()
	var new_rock = stone_block.instantiate()
	ability_spawn_container.add_child(new_rock)
	new_rock.global_position = pos
	new_rock.global_rotation = rot
	current_rock = new_rock


func start_cooldown(duration=ability_cooldown):
	is_on_cooldown = true
	$EarthAbilityCooldown.start(duration)


func _on_earth_attack_cooldown_timeout():
	is_on_cooldown = false
