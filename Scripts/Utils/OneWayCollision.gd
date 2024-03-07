extends StaticBody3D

@export var extend_exit = 1
@export var offset_enter = 0.6
@export var extend_enter = 2
@export var inflate = 0.1
@export_flags_3d_physics var entity_layer = 0b1000

@export_group("Overrides")
@export var enter_area_override: Area3D
@export var exit_area_override: Area3D

var add_exception_on_exit = []

@onready var enter_area = Area3D.new()
@onready var exit_area = Area3D.new()

func _ready():
	if enter_area_override != null and exit_area_override != null:
		enter_area = enter_area_override
		exit_area = exit_area_override
		connect_area3ds(enter_area, exit_area)
		return
	enter_area.create_shape_owner(enter_area)
	exit_area.create_shape_owner(exit_area)
	
	enter_area.priority = 10
	
	enter_area.collision_layer = 0
	exit_area.collision_mask = entity_layer
	
	var meshes = []
	
	for _owner in get_shape_owners():
		for i in range(shape_owner_get_shape_count(_owner)):
			var shape = shape_owner_get_shape(_owner, i)
			meshes.append(shape.get_debug_mesh())
			for _o in enter_area.get_shape_owners():
				var offset_shape = shape.duplicate()
				if "points" in offset_shape:
					for p in range(len(offset_shape.points)):
						offset_shape.points[p] -= Vector3(0, extend_enter, 0)
				enter_area.shape_owner_add_shape(_o, offset_shape)
				enter_area.shape_owner_add_shape(_o, shape)
			
			for _o in exit_area.get_shape_owners():
				exit_area.shape_owner_add_shape(_o, shape)
	
#	var aabb = null
#	for mesh in meshes:
#		if aabb == null:
#			aabb = mesh.get_aabb()
#		else:
#			aabb.merge(mesh.get_aabb())
#
#	aabb = aabb.abs()
	
	enter_area.position -= Vector3(0, offset_enter, 0)
	enter_area.scale += Vector3.ONE * inflate
	exit_area.position = Vector3(0, extend_exit, 0)
	
	add_child(enter_area)
	add_child(exit_area)
	
	if enter_area_override != null:
		enter_area = enter_area
	if exit_area_override != null:
		exit_area = exit_area_override
	
	connect_area3ds(enter_area, exit_area)


func connect_area3ds(enter, exit):
	enter.connect("body_entered", add_collision_exception_with)
	exit.connect("body_entered", _on_area_exit)
	exit.connect("body_exited", _on_area_exit_exit)


func _on_area_exit_exit(body: Node3D):
	remove_collision_exception_with(body)
	if add_exception_on_exit.has(body):
			add_exception_on_exit.remove_at(add_exception_on_exit.find(body))

func _on_area_exit(body: Node3D):
	if enter_area.overlaps_body(body):
		if !add_exception_on_exit.has(body):
			add_exception_on_exit.append(body)
	else:
		remove_collision_exception_with(body)


func _physics_process(_delta):
	for body in enter_area.get_overlapping_bodies():
		add_collision_exception_with(body)
	for body in add_exception_on_exit:
		if !enter_area.overlaps_body(body):
			add_exception_on_exit.remove_at(add_exception_on_exit.find(body))
			remove_collision_exception_with(body)
