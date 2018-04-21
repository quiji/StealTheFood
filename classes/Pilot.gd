extends KinematicBody2D

var stats = {
	top_speed = 180,
	camera_points = 1
}


enum MOVE_DIRECTIONS {MOVE_LEFT, MOVE_RIGHT}

var direction = Vector2(-1, 0)
var target_direction = null
var velocity = Vector2(-1, 0)

func _ready():
	add_to_group("FlyingFellas")
	velocity *= stats.top_speed

	if has_node("propeller"):
		$propeller/anim_player.play("Propel")


func process_ai(delta):
	pass
	
	
func _physics_process(delta):
	process_ai(delta)

	if target_direction != null and target_direction == MOVE_RIGHT:
		direction = (20 * direction - direction.tangent()).normalized()

	elif target_direction != null and target_direction == MOVE_LEFT:
		direction = (20 * direction + direction.tangent()).normalized()

		
	velocity = stats.top_speed * direction
	var collision_data = move_and_collide(velocity * delta)

	rotation = direction.angle()
	
	if collision_data != null and collision_data.collider.has_method("collided"):
		collision_data.collider.collided()
		collided()

func collided():
	queue_free()

func get_camera_values():
	return { pos = position, camera_points = stats.camera_points }

