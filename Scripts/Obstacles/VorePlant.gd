extends Node3D

@export var Damage = 10.0

@onready var animation_player = $Graphics/venusflytrap/AnimationPlayer

var captured_nodes = []

var attacking = false

func _on_owchie_zone_body_entered(body):
	await attack()


func _physics_process(delta):
	for node in captured_nodes:
		if is_instance_valid(node):
			node.global_position = %ShovePoint.global_position
		else:
			captured_nodes.remove_at(captured_nodes.find(node))

func attack():
	if not attacking:
		$Sounds/Attack.play()
		attacking = true
		animation_player.play("venusflytrap_static_idle")
		await get_tree().create_timer(1.0, false, true).timeout
		animation_player.play("venusflytrap_static_snapping")
		await get_tree().create_timer(0.1, false, true).timeout
		animation_player.stop()
		await hurt_entities()


func reset_attack():
	animation_player.play("venusflytrap_static_idle")
	animation_player.stop()
	attacking = false
	if %TriggerZone.has_overlapping_bodies():
		attack()


func hurt_entities():
	var dealt_damage = false
	for body in %TriggerZone.get_overlapping_bodies():
		body.global_position = %ShovePoint.global_position
		if body.has_method("DealDamage"):
			body.DealDamage(Damage)
			dealt_damage = true
		captured_nodes.append(body)
	
	if dealt_damage:
		$Sounds/Nom.play()
		animation_player.play("venusflytrap_static_playerchew")
		await animation_player.animation_finished
	for node in captured_nodes:
		if node.has_method("ResetPosition"):
			node.ResetPosition()
	$Sounds/Retract.play()
	animation_player.play("venusflytrap_static_snapping")
	animation_player.advance(0.1)
	captured_nodes.clear()
	await get_tree().create_timer(0.9, false, true).timeout
	animation_player.stop()
	reset_attack()
