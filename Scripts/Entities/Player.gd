extends Entity
class_name Player



@export_category("Player Adjustments")
@export var MaxHP = 100
@export var DAMAGE = 10
@export var iDuration = 1.0
@export var trauma_regress = 0.1

var current_iduration = 0
var trauma = 0.0

@export_category("Movement Adjustments")
@export var SPEED = 15
@export var JUMP_VELOCITY = 11
@export var punch_decrease = 1.0
@export var max_punch = 40.0
@export var coyote_time = 0.1
var player_rotation = 0
var rotation_speed = 15
var jump_able = false # variable needed for coyote time
var current_coyote_time = 0.0

var last_y_velocity = 0.0


@export_category("Features Adjustments")

@export_group("Melee Attack")
@export var melee_damage = 12.0
@export var melee_cooldown = 0.3
@export var melee_knockback = Vector3(15, 13, 0)

var current_melee_cooldown = 0.0



@export_group("Abilities")

@export var ability_container: Node3D
@export var start_ability = 0
@export var abilities: Array[PackedScene]

var instantiated_abilities = []

var current_ability: BaseSkill


###########################
# Character Leveling System
###########################


var level = 1
var experience = 0
var experience_required = get_required_exp(level + 1)
var experience_total = 0


###########################
# others, to sort.
###########################


@onready var anim_tree = $AnimationTree

var current_health = 0
var last_direction = 1
var last_movement := Vector3.ZERO
var timer_on = false

var punch_impact = 1.0
var temp_punch_impact = 0.0

var fragments = 0
var is_dead = false

var player_data = {}
var load_player_data = false

signal ability_changed(ability: BaseSkill)
signal vitality_changed(current_hp, max_health)
signal fragment_collected(fragments)


func _ready():
	super()
	randomize()
	
	current_health = MaxHP
	
	instantiate_abilities()


func _physics_process(delta):
	if is_dead:
		return
	apply_gravity(delta)
	process_coyote_time(delta)
	calculate_punch()
	process_iDuration(delta)
	move_and_slide()
	super(delta)


# Handle Animations outside of the physics loop. (aka don't mix physics and visuals)
func _process(delta):
	if load_player_data:
		LoadPlayerData(player_data)
	if is_dead:
		return
	super(delta)
	# Handle Input in Process because we usually have more frames in here.
	# Also because when testing Michel pointed out that there seems to be an input delay
	# which probably only is because _process gets called more frequently than _physics_process
	# Change look direction. Could be made smoother too!
	update_rotation()
	handle_trauma(delta)
	process_state_machine(delta)
	process_melee_cooldown(delta)


#####################################################################
#################    Ability Functions   ############################
#####################################################################


func SetPlayerData(data):
	player_data = data
	load_player_data = true


func LoadPlayerData(data):
	load_player_data = false
	
	if "score" in data:
		fragments = data["score"]
		emit_signal("fragment_collected", fragments)
	
	if "health" in data:
		current_health = data["health"]
		emit_signal("vitality_changed", current_health, MaxHP)


func GetPlayerData():
	return {
		"score": fragments,
		"health": current_health
	}


func instantiate_abilities():
	for ability in abilities:
		var instance = ability.instantiate()
		add_child(instance)
		instance.Setup(self, ability_container)
		instantiated_abilities.append(instance)


func set_ability(ability_idx):
	if not current_ability == null:
		current_ability.Destroy()
		current_ability.visible = false
		current_ability.process_mode = Node.PROCESS_MODE_DISABLED
	
	var new_ability = instantiated_abilities[ability_idx]
	
	new_ability.Setup(self, ability_container)
	current_ability = new_ability
	
	current_ability.visible = true
	current_ability.process_mode = Node.PROCESS_MODE_INHERIT
	
	emit_signal("ability_changed", current_ability)


func toggle_ability():
	start_ability += 1
	if start_ability >= len(instantiated_abilities):
		start_ability = 0
	if start_ability < len(instantiated_abilities):
		set_ability(start_ability)


#####################################################################
#################    Fight Functions     ############################
#####################################################################


func DealDamage(Damage):
	if is_dead:
		return
		
	if current_iduration > 0.0:
		return
	current_iduration = iDuration
	current_health -= Damage
	emit_signal("vitality_changed", float(current_health), float(MaxHP))
	$SoundPlayer.play("Player/hit")
	if current_health <= 0:
		die()


func Absorbed(exp: float):
	if is_dead:
		return
		
#	experience += exp
	current_health = clamp(exp + current_health, 0, 100)
	emit_signal("vitality_changed", float(current_health), float(MaxHP))


func absorb():
	var bodies = $AbsorbArea.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("AbsorbMonster"):
			body.AbsorbMonster(self)


func process_iDuration(delta):
	current_iduration = clampf(current_iduration - delta, 0.0, iDuration)

#####################################################################
#################    Leveling Functions     #########################
#####################################################################


func get_required_exp(level):
	return round(pow(level, 1.8) + level * 4)


# Check this formula below.
# https://www.desmos.com/calculator/obopqlufy9
func gain_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()


func level_up():
	level += 1
	experience_required = get_required_exp(level + 1)
	var stats = ['MaxHP', 'DAMAGE']
	# Picks one random stat from the pool above to boost up.
	var random_stat = stats[ randi() % stats.size() ]
	# Increases the selected stat by a random amount between 2 and 8
	set(random_stat, get(random_stat) + randi() % 8 + 2)


#####################################################################
#################   Movement Functions   ############################
#####################################################################


func update_rotation():
	$PlayerModel.rotation_degrees.y = lerpf(90 * last_direction, $PlayerModel.rotation_degrees.y, 0.6)


func PunchUnclamped(punch_velocity: Vector3, override_punch = false):
	trauma += clampf(0.5 - trauma, 0.0, 0.5)
	if override_punch:
		velocity = punch_velocity
	else:
		velocity += punch_velocity
	punch_impact = velocity.length()
	temp_punch_impact = punch_impact


func Punch(punch_velocity: Vector3, override_punch = false):
	var max_punch_vector = Vector3.ONE * max_punch
	trauma += clampf(0.5 - trauma, 0.0, 0.5)
	if override_punch:
		velocity = punch_velocity
	else:
		velocity += punch_velocity
	velocity = velocity.clamp(-max_punch_vector, max_punch_vector)
	punch_impact = velocity.length()
	temp_punch_impact = punch_impact


func calculate_punch():
	temp_punch_impact = clampf(temp_punch_impact - punch_decrease, 0.0, punch_impact)
	if last_movement.length() > 0.0:
		velocity.x = lerpf(last_movement.x * SPEED, velocity.x, lerpf(0.5, 1.0, temp_punch_impact / punch_impact))
		last_direction = 1 if last_movement.x > 0 else -1
	else:
		velocity.x = lerpf(move_toward(velocity.x, 0, SPEED), velocity.x, temp_punch_impact / punch_impact)	


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		last_y_velocity = velocity.y
	else:
		if not jump_able:
			$JumpStumpVFX.play()
		if last_y_velocity < -100.0:
			last_y_velocity = 0.0
			trauma += 0.4


func process_coyote_time(delta):
	if is_on_floor():
		jump_able = true
		current_coyote_time = coyote_time
	
	if jump_able and velocity.y > 0:
		jump_able = false
	elif not is_on_floor() and current_coyote_time > 0:
		current_coyote_time = clampf(coyote_time, 0, current_coyote_time - delta)
	elif current_coyote_time <= 0:
		jump_able = false


func jump():
	if jump_able:
		global_position += Vector3(0, 0.1, 0)
		velocity.y = JUMP_VELOCITY
		jump_able = false
		$SoundPlayer.play("Player/jump")


func melee_attack():
	if current_melee_cooldown > 0:
		return
	$ghost_hand.rotation.y = deg_to_rad(90) * last_direction
	current_melee_cooldown = melee_cooldown
	anim_tree.set("parameters/MeleeAttack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func melee_trigger():
	for body in %HurtArea.get_overlapping_bodies():
		if body.has_method("DealDamage"):
			body.DealDamage(melee_damage)
		if body.has_method("Punch"):
			body.Punch(Vector3(last_direction, 1, 0) * melee_knockback)


func die():
	trauma = 0.0
	process_mode = Node.PROCESS_MODE_ALWAYS
	is_dead = true
	Game.game_over()
	Game.get_current_rig().set_offset(Vector3(0, 2, 14.0))
	Game.get_current_rig().toggle_overlays(true)
	Game.get_current_rig().screenshake_enabled = false
	anim_tree.set("parameters/death_time/seek_request", 0)
	anim_tree.set("parameters/dead/blend_amount", 1.0)
	$PlayerModel/death_flower/AnimationPlayer.play("Action")
	$SoundPlayer.play("Player/die")


func process_melee_cooldown(delta):
	current_melee_cooldown = clampf(current_melee_cooldown - delta, 0, melee_cooldown)


func handle_trauma(delta):
	trauma = clampf(trauma - trauma_regress * delta, 0.0, 1.0)


func _unhandled_input(event):
	if event.is_action_pressed("jump", true):
		jump()
		get_viewport().set_input_as_handled()
	
	
	if event.is_action_pressed("attack"):
		melee_attack()
		get_viewport().set_input_as_handled()
	
	
	if event.is_action_pressed("absorb"):
		absorb()
		get_viewport().set_input_as_handled()
	
	
	if event.is_action("move_left") or event.is_action("move_right"):
		last_movement.x = Input.get_axis("move_left", "move_right")
		get_viewport().set_input_as_handled()
	
	for ability in instantiated_abilities:
		ability.Use(event)


func set_condition(condition_name, condition_value):
	anim_tree.set("parameters/StateMachine/conditions/" + condition_name, condition_value)


func process_state_machine(_delta):
	set_condition("is_jumping", !is_on_floor() and velocity.y > 0)
	set_condition("is_on_floor", is_on_floor())
	set_condition("is_falling", !is_on_floor() and velocity.y < 0)
	anim_tree.set("parameters/hurt_amount/blend_position", 1.0 if current_iduration > 0.0 else 0.0)
	anim_tree["parameters/StateMachine/IdleWalk/IdleWalkBlend/blend_amount"] = abs(velocity.x / SPEED)


func PickUp(item):
	fragments += item
	emit_signal("fragment_collected", fragments)
