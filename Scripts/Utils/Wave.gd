extends Node
class_name Wave

@export_category("Spawn Option")

@export var monster_Count = 10
@export var cooldown_spawn = 2.0

@export_category("Optional Enemy modificatior")
#optionally, developers can create "harder" waves of monsters to defeat. (not required)
#the monster's original value will be multiplied by the multiplier value.
#1 is the default value. (x * 1 = x)
@export var multiplier_HP:float = 1				#Enemy -> Max_Stun (Hp == stun)
@export var multiplier_Scale:float = 1			#Enemy -> Scale
@export var multiplier_Move_Speed:float = 1		#Enemy -> MoveSpeed
@export var multiplier_Damage:float = 1			#Enemy -> Damage
