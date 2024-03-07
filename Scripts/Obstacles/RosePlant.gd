extends Node3D

@export var knockback = Vector2(30.0, 10.0)
@export var relative_knockback = false
@export var Damage = 1.0



func _ready():
	$HurtArea.knockback = knockback
	$HurtArea.relative_knockback = relative_knockback
	$HurtArea.Damage = Damage


func _on_child_exiting_tree(node):
	if get_child_count() - 1 <= 4:
		$AnimationPlayer.play("rose_close")


func add_thorn(node):
	if node.owner == self:
		return false
	add_child(node)
	return true


func remove_thorn(node):
	if node.owner != self:
		return false
	remove_child(node)
	return true
