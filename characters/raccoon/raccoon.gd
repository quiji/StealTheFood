extends "res://classes/Pilot.gd"




func configure():
	stats.top_speed = 280
	stats.armor = 6

	Glb.set_shields(stats.armor)

func process_ai(delta):

	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		target_direction = null
	
	if Input.is_action_pressed("ui_left"):
		target_direction = MOVE_LEFT
	
	if Input.is_action_pressed("ui_right"):
		target_direction = MOVE_RIGHT

	if Input.is_action_pressed("shoot"):
		shoot_bullet()

func pilot_failed():
	Glb.raccoon_failed()

func on_damage_received(n):
	Glb.remove_shields(n)
