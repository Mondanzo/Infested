extends Enemy_Base

@export var IDLE_Target: Node3D

@onready var raycast_Xp = $"_Enemy/Detectors/RayCasts_FLY/RageZone_X+"
@onready var raycast_Yp = $"_Enemy/Detectors/RayCasts_FLY/RageZone_Y+"
@onready var raycast_Xm = $"_Enemy/Detectors/RayCasts_FLY/RageZone_X-"
@onready var raycast_Ym = $"_Enemy/Detectors/RayCasts_FLY/RageZone_Y-"
@onready var raycast_XYp = $"_Enemy/Detectors/RayCasts_FLY/RageZone_XY+"
@onready var raycast_XpYm = $"_Enemy/Detectors/RayCasts_FLY/RageZone_X+Y-"
@onready var raycast_XYm = $"_Enemy/Detectors/RayCasts_FLY/RageZone_XY-"
@onready var raycast_XmYp = $"_Enemy/Detectors/RayCasts_FLY/RageZone_X-Y+"

@onready var raycast_target = $_Enemy/Graphic/Target_Detector
@onready var graphic_armature = $_Enemy/Graphic/Armature

var is_target_reached = false


func _ready():
	super._ready()
	state = { IDLE = false, CHASE = false, PICK = false, DEAD = false }
	change_state("IDLE",true)
	


	
func _physics_process(delta):
	update_rotation()
	handle_raycast_collisions()


	move_and_slide()


func change_state(enemy_state,bool):
	if state["DEAD"]:
		
		return

	state[enemy_state] = bool

	if bool == true:
		if enemy_state == "IDLE" or enemy_state == "CHASE":
			play_full_animation("Animation_FLY")
		elif enemy_state == "PICK":
			play_full_animation("Animation_ATTACK")
		elif enemy_state == "DEAD":
			$Sounds/SoundFly.stop()
			$Sounds/SoundDie.play()
			velocity = Vector3.ZERO
			play_full_animation("Animation_DEATH")
			reset_all_states_except_direct("DEAD")
	
func update_rotation():
	if state["DEAD"]:
		return
	if state["PICK"] and is_target_reached:
		var direction = Target.position - global_transform.origin
		graphic_armature.look_at(global_transform.origin + (direction* -1), Vector3.UP)
		play_full_animation("Animation_FLY")
	elif state["IDLE"]:
		graphic_armature.look_at(IDLE_Target.position, Vector3.UP)
	else:
		graphic_armature.look_at(Target.position, Vector3.UP)


func play_full_animation(animation_name):
	animation_player.play(animation_name)

func handle_raycast_collisions():
	if !state["DEAD"]:
		if raycast_Xp.is_colliding():
			velocity.x += -0.1
		if raycast_XYp.is_colliding():
			velocity.x += -0.1
			velocity.y += -0.1
		if raycast_XmYp.is_colliding():
			velocity.x += 0.1
			velocity.y += -0.1
		if raycast_Yp.is_colliding():
			velocity.y += -0.1
		if raycast_Xm.is_colliding():
			velocity.x += 0.1
		if raycast_Ym.is_colliding():
			velocity.y += 2
		
###########################################################
#####################  Detectors  #########################
###########################################################

##### PLAYER DETECTOR ZONE
func _on_player_detector_body_entered(body):
	if body == Target:
		reset_all_states_except("CHASE")

func _on_player_detector_body_exited(body):
	if body == Target:
		if state["PICK"]:
			reset_all_states_except("CHASE")
		else:
			reset_all_states_except("IDLE")



##### ATTACK ZONE
func _on_attack_zone_body_entered(body):
	if body == Target:
		if !state["DEAD"]:
			attack()


func _on_attack_zone_body_exited(body):
	if body == Target:
		pass


