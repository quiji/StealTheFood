extends "res://classes/Pilot.gd"

func _ready():
	stats.top_speed = 200
	stats.camera_points = 0.5
	._ready()

func process_ai(delta):

	target_direction = MOVE_LEFT
