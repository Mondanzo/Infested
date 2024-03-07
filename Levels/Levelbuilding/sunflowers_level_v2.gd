extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$enemies/Path3D/PathFollow3D.progress_ratio += 0.3*delta
	$enemies/Path3D2/PathFollow3D.progress_ratio += 0.3*delta
