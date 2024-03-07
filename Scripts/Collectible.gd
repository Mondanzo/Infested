extends Node3D

@export_range(1, 10, 1, "hide_slider", "or_greater") var soul_fragments = 1

var can_be_picked_up = true

func _ready():
	$DebugShape.visible = false
	$GPUParticles3D.emitting = true

func on_body_entered(body: Node3D):
	if not can_be_picked_up:
		return
	can_be_picked_up = false
	if body.has_method("PickUp"):
		body.PickUp(soul_fragments)
		$AnimationPlayer.play("destroy")
