extends Node3D
class_name Spawner

#Export Variables.
@export var Monster: PackedScene
@onready var $Spawn_Timer = $Spawn_Cooldown
@export var monster_Wave = 5
@export var Target:Node3D

var monster_total = 0
var enemy_remaining_to_spawn
var waves #list of all the Waves Nodes: [ Wave0, Wave1, Wave2, ... ]
var current_wave:Wave #Wave Node
var current_wave_number = -1
var kills_on_current_wave




#Functions
func _ready():
	waves = $Wave_Manager.get_children()
	start_next_wave()
	
	

func Spawn_Monster():
	
	if enemy_remaining_to_spawn > 0:
		var enemy = Monster.instantiate()
		var scene_root = get_parent()
		scene_root.add_child(enemy)
		enemy.Target = Target
		enemy.global_position = global_position
		enemy.apply_statistic(
			current_wave.multiplier_HP,
			current_wave.multiplier_Scale,
			current_wave.multiplier_Move_Speed,
			current_wave.multiplier_Damage
		)
		enemy.connect("on_death",monster_is_dead)
		enemy_remaining_to_spawn -= 1
	else:
		if kills_on_current_wave == current_wave.monster_Count:
			start_next_wave()

func monster_is_dead():
	kills_on_current_wave += 1
	print("Enemies killed: ", kills_on_current_wave, "/",current_wave.monster_Count )
	
func start_next_wave():
	kills_on_current_wave = 0
	current_wave_number += 1
	if current_wave_number < waves.size():
		current_wave = waves[current_wave_number]
		enemy_remaining_to_spawn = current_wave.monster_Count
		$Spawn_Timer.wait_time = current_wave.cooldown_spawn
		$Spawn_Timer.start()
	
func _on_spawn_cooldown_timeout():
	Spawn_Monster()
