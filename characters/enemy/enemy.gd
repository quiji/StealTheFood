extends "res://classes/Pilot.gd"


func _ready():
	stats.top_speed = 200
	stats.camera_points = 0.5


func process_ai(delta):

	var target = get_parent().get_raccoon()

	if target != null:
	
		var target_vector = (target.position - position).normalized()
	
		if target_vector.dot(direction) > 0.7:
			target_direction = null
		else:
			var left_vector = direction.tangent()
			var right_vector = -left_vector
			
			var dot_left = left_vector.dot(target_vector)
			var dot_right = right_vector.dot(target_vector)
			
			if dot_left > dot_right:
				target_direction = MOVE_LEFT
			else:
				target_direction = MOVE_RIGHT
	
		