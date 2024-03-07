extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Enemies/Flies/Path3D_Fly/PathFollow3D_Fly.progress_ratio += 0.3*delta
	$Enemies/Flies/Path3D_Fly2/PathFollow3D_Fly2.progress_ratio += 0.3*delta
	$Enemies/Flies/Path3D_Fly3/PathFollow3D_Fly3.progress_ratio += 0.3*delta
	$Enemies/Flies/Path3D_Fly4/PathFollow3D_Fly4.progress_ratio += 0.3*delta
	$Enemies/Flies/Path3D_Fly5/PathFollow3D_Fly5.progress_ratio += 0.3*delta
	$Enemies/Flies/Path3D_Fly6/PathFollow3D_Fly6.progress_ratio += 0.3*delta
