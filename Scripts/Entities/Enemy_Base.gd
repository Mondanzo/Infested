extends Entity
class_name Enemy_Base

#Target is on export for case that our GD wanna set Enemy in background.
@export var Target: Node3D = null 

@export_category("Enemy Stats")
@export var MaxHP = 100
@export var MoveSpeed = 4.0		#Move and Fly speed as normal ( not rage ) 
@export var RageSpeed = 8.0			#Move and Fly speed as Rage
@export var Damage = 5.0			#Damage what do Enemy
@export var LifeToSteal = 2			#HP that Player receives after Monster Absorb

@onready var HP = MaxHP
@onready var animation_player:AnimationPlayer = $_Enemy/Graphic/Animation


var anim_finish = true
var current_animation = "Animation_IDLE"

var state:Dictionary	#Override this in the subscript for the enemy.


signal on_death()



func _ready():
	#Automatic player targeting. I was annoyed with assigning "Target" in every Enemy in a level.
	if Target == null:
		Target = get_tree().get_current_scene().get("player")
		if Target == null:
			
			Target = Game.getPlayer()
		
	super()
	

func _physics_process(delta):
	super(delta)
	apply_gravity(delta)
	update_rotation()
	move_and_slide()


###########################################################
###############  Simple small Functions  ##################
###########################################################

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


func play_full_animation(animation_name):
	if anim_finish:
		animation_player.play(animation_name)
	if animation_name == "Animation_ATTACK":
		anim_finish = false
		await animation_player.animation_finished
		anim_finish = true


func attack():
	Target.DealDamage(Damage)


func DealDamage(Damage):
	if state["DEAD"]:
		return
	HP	-= Damage
	if HP <= 0:
		change_state("DEAD", true)
		

func AbsorbMonster(killer: Player):
	if state["DEAD"]:
		if killer.has_method("Absorbed"):
			killer.Absorbed(LifeToSteal)
			emit_signal("on_death")
			queue_free()
			

func Punch(_velocity: Vector3, _replace_velocity = false):
	self.velocity = _velocity


func reset_all_states_except(exception):
	for i in state:
		if i == exception:
			change_state( i, true )
		else:
			change_state( i, false )


func reset_all_states_except_direct(exception):
	for i in state:
		if i == exception:
			state[i] = true
		else:
			state[i] = false

#The following functions will be overridden by subclasses
func detect_wall():
	pass

func detect_player():
	pass

func update_rotation():
	pass

func change_state(enemy_state,bool):
	pass
