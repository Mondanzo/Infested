extends Node3D

@export var anticipation_time = 1.2
@export var rebuild_time = 5.0

var is_ready = true

func _on_trigger_zone_body_entered(_body):
	if not is_ready:
		return
	is_ready = false
	$AnimationPlayer.play("anticipation")
	await get_tree().create_timer(anticipation_time).timeout
	$AnimationPlayer.play("destroy")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(rebuild_time).timeout
	$AnimationPlayer.play("rebuild")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("RESET")
	is_ready = true
	if $TriggerZone.has_overlapping_bodies():
		_on_trigger_zone_body_entered(null)
