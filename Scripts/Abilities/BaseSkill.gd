extends Node3D
class_name BaseSkill

@export_category("UI Elements")
@export var ability_icon: Texture2D = PlaceholderTexture2D.new()
@export var ability_name: String = "Ability"

var ability_spawn_container: Node3D
var user: Node3D

func Setup(player: Node3D, ability_spawn_container: Node3D):
	user = player
	self.ability_spawn_container = ability_spawn_container


func Destroy():
	pass


func MaxCooldown():
	return 0


func CurrentCooldown():
	return 0


func CooldownPercentage():
	if MaxCooldown() == 0:
		return 1
	return CurrentCooldown() / MaxCooldown()


func Use(event: InputEvent):
	pass
