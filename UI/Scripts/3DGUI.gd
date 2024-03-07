extends Node3D
class_name Menu3DWrapper

func set_root_menu(node):
	print("Root node is ", node.name)
	for child in $MenuViewport.get_children():
		if child.has_method("set_root_menu"):
			child.set_root_menu(node)


func on_enter():
	for child in $MenuViewport.get_children():
		if child.has_method("on_enter"):
			child.on_enter()


# The last processed input touch/mouse event. To calculate relative movement.
var last_mouse_pos2D = Vector2()
var last_velocity = Vector2()

@onready var node_viewport = $MenuViewport
@onready var node_area = $ClickArea


func _ready():
	for child in get_children():
		if child is Control:
			child.reparent(node_viewport)


func _input(event):
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if event is mouse_event:
			return
	node_viewport.push_input(event)


func _on_click_area_input_event(camera, event, position, normal, shape_idx):
	var shape_size = node_area.shape_owner_get_shape(0, shape_idx).size
	var normalised = (to_local(position) + shape_size / 2) / shape_size
	var final_pos = Vector2(normalised.x, 1 - normalised.y) * Vector2(node_viewport.size)
	
	if event is InputEventMouseMotion:
		if last_mouse_pos2D == null:
			last_mouse_pos2D = Vector2(0, 0)
		else:
			last_velocity = final_pos - last_mouse_pos2D
	last_mouse_pos2D = final_pos
	
	if normalised.x < -0.01 or normalised.y < -0.01 or normalised.x > 1.01 or normalised.y > 1.01:
		return
	
	event.position = last_mouse_pos2D
	event.global_position = last_mouse_pos2D
	if event is InputEventMouseMotion:
		event.relative = last_velocity
	
	node_viewport.push_input(event)
