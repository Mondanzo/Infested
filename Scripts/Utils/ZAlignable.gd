extends CharacterBody3D
class_name Entity

var z_index_to_force: float = 0.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_z_lock(new_value):
	z_index_to_force = new_value


func _ready():
	z_index_to_force = global_position.z


func _process(delta):
	pass


func _physics_process(delta):
	global_position.z = lerpf(global_position.z, z_index_to_force, 0.4)
