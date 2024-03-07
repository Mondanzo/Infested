extends Enemy_Base

@export var IDLE_Target: Node3D

@onready var raycast_target = $_Enemy/Graphic/Target_Detector
@onready var graphic_armature = $_Enemy/Graphic/Armature
var is_target_reached = false


func _ready():
	super._ready()
	state = { IDLE = false, CHASE = false, PICK = false, DEAD = false }
	change_state("CHASE",true)

func _physics_process(delta):
	update_rotation()

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


###########################################################
#####################  Detectors  #########################
###########################################################

##### ATTACK ZONE
func _on_attack_zone_body_entered(body):
	if body == Target:
		if !state["DEAD"]:
			attack()


func _on_attack_zone_body_exited(body):
	if body == Target:
		pass
