extends Path3D

@export var procent_per_second = 0.03
@export var use_spawn = true
@export var object_count = 1
@export var object_node:PackedScene = null


func _ready():
	if use_spawn:
		exe_spawn_object()



func _process(delta):
	for child in get_children():
		if child is PathFollow3D:
			exe_path(child,delta)
	
	
func exe_path(node,delta):
	if node.progress_ratio >= 1:
		node.progress_ratio = 0
	else:
		node.progress_ratio += procent_per_second * delta
		
func exe_spawn_object():
	if object_node == null:
		return
	else:
		var distance_between = 1.0 / object_count
		for i in range(object_count):
			var object_temp = object_node.instantiate()
			
			add_child(object_temp)
			object_temp.progress_ratio = i * distance_between
			print(i*distance_between)

