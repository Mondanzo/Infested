@tool
extends Control

@export var label = "Button" :
	get:
		return label
	set(value):
		label = value
		update_label = true

var update_label = false

func _process(delta):
	if update_label:
		$Label.text = label
