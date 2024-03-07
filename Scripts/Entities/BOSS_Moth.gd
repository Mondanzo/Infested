extends Enemy_Base


@onready var graphic_armature = $_Enemy/Graphic/Armature
@onready var laser_node = $Attack/Silk_Windmill
@onready var summon_fly_scene = preload("res://Objects/Entities/SUMMON_Fly.tscn")
@onready var bomb_scene = preload("res://Objects/Level Assets/Obstacles/Bomb.tscn")
@onready var wingflap_attack_scene = preload("res://Objects/Level Assets/Obstacles/PoisonCloud.tscn")

@export var PathStage1:PathFollow3D	#Path for Boss on stage 1
@export var PathStage2:PathFollow3D	#Path for Boss on stage 2
@export var PointStage3:Node3D		#Point for Boss on stage 3

#The minimum and maximum time on which the bomb_scene Spawn Timer operates.
@export var BombMinTime:float = 1.0
@export var BombMaxTime:float = 2.0

#seconds in which the attack will turn 360 degrees
@export var WindmillRotationTime:float = 12.0
#The minimum and maximum time on which the WINGFLAP Spawn Timer operates.
@export var WingflapMinTime:float = 5.0
@export var WingflapMaxTime:float = 10.0

#Number of SUMMON_FLY to spawn.
@export var SummonFlySpawnCount = 5
@export var ChanceToSpawn = 70  # procent chance to spawn fly summons

#Various variables needed for this spaghetti code to work
var stand_mode = false
var can_attack = false
var stage_3_init_started = false
var lives = 2
var current_boss_stage = 1
var stage_max_hp = { STAGE_1 = 300, STAGE_2 = 400, STAGE_3 = 650 }


func _ready():
	super._ready()
	state = { STAGE_1 = false, STAGE_2 = false, STAGE_3 = false, DEAD = false }
	change_state("STAGE_3",true)


func _physics_process(delta):
	update_rotation()
	update_animation()
	rotate_windmill_node(delta)

	move_and_slide()



func DealDamage(Damage):
	if state["DEAD"]:
		return
	HP	-= Damage
	
	if HP <= 0:
		if lives > 0:
			lives -= 1
			current_boss_stage += 1
			reset_all_states_except("STAGE_" + str(current_boss_stage) )
		else:
			reset_all_states_except("DEAD")
	

func change_state(enemy_state,bool):
	if state["DEAD"]:
		return
		
	state[enemy_state] = bool
	
	if bool == true:
		if enemy_state != "DEAD":
			set_MAX_HP(enemy_state)
		else:
			play_full_animation("moth_death_animation")
			reset_all_states_except_direct("DEAD")


func update_animation():
		if state["STAGE_1"] or (state["STAGE_2"] and !stand_mode) or (state["STAGE_3"] and !can_attack):
			play_full_animation("moth_fly_animation")
		elif (state["STAGE_2"] and stand_mode) or (state["STAGE_3"] and can_attack):
			play_full_animation("moth_aoe_animation")


func update_rotation():
	if state["DEAD"]:
		return
	elif state["STAGE_1"]:
		graphic_armature.look_at(PathStage1.position, Vector3.UP)	
	elif state["STAGE_2"] and !stand_mode:
		graphic_armature.look_at(PathStage2.position, Vector3.UP)	
	elif state["STAGE_3"] and !stage_3_init_started:
		graphic_armature.look_at(PointStage3.position, Vector3.UP)
	elif (state["STAGE_3"] and stage_3_init_started) or (state["STAGE_2"] and stand_mode):
		graphic_armature.look_at(global_position + Vector3.BACK, Vector3.UP)


func play_full_animation(animation_name):
	animation_player = $_Enemy/Graphic/AnimationPlayer
	animation_player.play(animation_name)


func set_MAX_HP(stage):
	MaxHP = stage_max_hp[stage]
	HP = MaxHP


func follow_target(delta,current_target):
	var direction = (current_target.global_transform.origin - global_transform.origin).normalized()

	if direction.length() < 0.1:
		velocity = Vector3.ZERO
	else:
		velocity = MoveSpeed * direction	


func spawn_bomb():
	var bomb_scene = bomb_scene.instantiate()
	get_parent().add_child(bomb_scene)
	bomb_scene.set_global_position(global_position)


func rotate_windmill_node(delta):
	if laser_node.visible == true:
		var rotation_angle =   360.0 / WindmillRotationTime * delta
		laser_node.rotate_object_local(Vector3(0, 0, 1), rotation_angle * delta)


func spawn_wingflap_area():
	var area = wingflap_attack_scene.instantiate()
	get_parent().add_child(area)
	area.set_global_position(global_position)


func update_path_progress_with_speed(path, delta, speed):
	path.progress += speed * delta


func spawn_summon_fly():
	var chance = randi_range(1,100)
	if chance <= ChanceToSpawn:
		for i in range(SummonFlySpawnCount):
			var object_temp = summon_fly_scene.instantiate()
			
			get_parent().add_child(object_temp)
			object_temp.global_transform.origin = global_transform.origin + random_vector3()
			object_temp.Target = Target


func random_vector3():
	var x = randi_range(-16, 16)
	var y = randi_range(-16, 16)
	while abs(x) < 10 or abs(y) < 10:
		x = randi_range(-16, 16)
		y = randi_range(-16, 16)
	return Vector3(x, y, 0)
