extends "res://classes/Pilot.gd"




func configure():
	stats.top_speed = 270
	stats.lives = 500


func process_ai(delta):

	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		target_direction = null
	
	if Input.is_action_just_pressed("ui_left"):
		target_direction = MOVE_LEFT
	
	if Input.is_action_just_pressed("ui_right"):
		target_direction = MOVE_RIGHT

	if Input.is_action_pressed("shoot"):
		shoot_bullet()

func pilot_failed():
	get_parent().raccoon_failed()
