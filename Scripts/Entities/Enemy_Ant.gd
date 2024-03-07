extends Enemy_Base

var last_direction:int

@onready var wall_raycast:RayCast3D = $_Enemy/Detectors/RayCasts_WALK/Wall_Detector
@onready var target_raycast:RayCast3D = $_Enemy/Detectors/RayCasts_WALK/Group_Point
@onready var ground_detector = $_Enemy/Detectors/RayCasts_WALK/GroundDetector

func _ready():
	super._ready()
	state = { IDLE = false, CHASE = false, RUN = false, ATTACK = false, DEAD = false }
	change_state("IDLE",true)


func update_rotation():
	if state["DEAD"]:
		return
	if state["RUN"]:
		await get_tree().create_timer(3.0).timeout
	else:
		look_at(Vector3(Target.global_transform.origin.x, global_transform.origin.y, Target.global_transform.origin.z), Vector3.UP)


func get_last_direction():

	if state["RUN"]:
		return last_direction
	if Target.position.x - position.x > 0:
		last_direction = 1
		return 1
	else:
		last_direction = -1
		return -1

func detect_wall():
	var detector = wall_raycast.get_collider()
	if detector != null:
		if !detector == Target:
			return true
		else:
			return false
	else:
		return false
		
func detect_player():
	var detector = target_raycast.get_collider()
	if detector != null:
		if detector == Target:
			return true
		else:
			return false
	else:
		return false


func change_state(enemy_state,bool):
	if state["DEAD"]:
		return
		
	state[enemy_state] = bool
	
	if bool == true:
		if enemy_state == "IDLE":
			play_full_animation("Animation_IDLE")
		elif enemy_state == "CHASE" or enemy_state == "RUN":
			play_full_animation("Animation_WALK")
		elif enemy_state == "ATTACK":
			play_full_animation("Animation_ATTACK")
		elif enemy_state == "DEAD":
			play_full_animation("Animation_DEATH")
			reset_all_states_except_direct("DEAD")
	
###########################################################
#####################  Detectors  #########################
###########################################################



##### PLAYER DETECTOR ZONE
func _on_player_detector_body_entered(body):
	if body == Target:
		reset_all_states_except("CHASE")

func _on_player_detector_body_exited(body):
	if body == Target:
		reset_all_states_except("IDLE")


##### ATTACK ZONE
func _on_attack_zone_body_entered(body):
	if body == Target:
		if !state["DEAD"]:
			play_full_animation("Animation_ATTACK")
			change_state("ATTACK",true)


func _on_attack_zone_body_exited(body):
	if body == Target:
		if !state["DEAD"]:
			play_full_animation("Animation_WALK")


