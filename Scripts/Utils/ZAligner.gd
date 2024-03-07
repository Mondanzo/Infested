extends Path3D

@export var follow_rotation = false

var tracked_nodes: Array[Node3D] = []

func _ready():
	# Just to make setting up z aligners easier.
	for child in get_children():
		if child is Area3D:
			child.connect("body_entered", AddTrackedNode)
			child.connect("area_entered", AddTrackedNode)
			child.connect("body_exited", RemoveTrackedNode)
			child.connect("area_exited", RemoveTrackedNode)


func _physics_process(delta):
	update_nodes()
	#prints("[" + name + "]", "handling", len(tracked_nodes), "nodes")


func AddTrackedNode(tracked_node: Node3D):
	tracked_nodes.append(tracked_node)


func RemoveTrackedNode(tracked_node: Node3D):
	tracked_nodes.remove_at(tracked_nodes.find(tracked_node))


func get_local_point_on_path_from_global_space(position: Vector3):
	return curve.get_closest_point(to_local(position))


func get_point_on_path_from_global_space(position: Vector3):
	return to_global(
		curve.get_closest_point(
			to_local(position)
			)
		)
	

func update_nodes():
	for node in tracked_nodes:
		if follow_rotation:
			var offset_point = curve.get_closest_offset(get_local_point_on_path_from_global_space(node.global_position))
			var point_transform = curve.sample_baked_with_rotation(offset_point, true, true)
			node.global_position.z = get_point_on_path_from_global_space(node.global_position).z
			node.global_rotation.y = Quaternion(point_transform.basis * Basis(Vector3.UP, -90)).get_euler().y
		else:
			var value_to_set = get_point_on_path_from_global_space(node.global_position).z
			node.global_position.z = value_to_set
			if node.has_method("set_z_lock"):
				node.set_z_lock(value_to_set)
