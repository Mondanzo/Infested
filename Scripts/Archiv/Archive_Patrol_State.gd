extends EnemyState


enum DIRECTION {LEFT = -1,RIGHT = 1}
var dir = DIRECTION.RIGHT

@onready var wall_detector = $"../../Detectors/Wall_Detector"
@onready var hole_detector = $"../../Detectors/Hole_Detector"

func _ready():
	print("State: Patrol")
	super._ready()
	timer = $Timer
	timer.wait_time = Enemy.looking_time

func _physics_process(delta):
	#exe_patrol_path(delta)
	exe_fallow_path(delta)


func exe_patrol_path(delta):
#	prints(dir, Enemy.patrol_path.progress_ratio, timer.time_left)
	Enemy.patrol_path.progress_ratio = clampf(Enemy.patrol_path.progress_ratio, 0, 1)
	var distance_to_point = Enemy.global_position.distance_to(Enemy.patrol_path.global_position)
	if distance_to_point <= 5:
		Enemy.patrol_path.progress += dir * Enemy.MoveSpeed * delta
		if Enemy.patrol_path.progress_ratio >= 1 or Enemy.patrol_path.progress_ratio <= 0:
			dir = -dir


func exe_fallow_path(delta):
	Enemy.velocity.x = dir * Enemy.MoveSpeed
	if Enemy.detect_wall(wall_detector):
		Enemy.Flip()
		dir *= -1
	
	
