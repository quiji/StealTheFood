extends Node2D


const MIN_DISTANCE_TO_RACCOON_TO_ACCEPT_POS = 600 * 600

const CAMERA_OFFSET = 100

const CAMERA_TOO_CLOSE = 20 * 20
const CAMERA_CLOSE = 50 * 50
const CAMERA_FAR = 500 * 500

const CAMERA_MOVEMENT_SPEED = 280
const CAMERA_MOVEMENT_TOP_SPEED = 320
const CAMERA_MOVEMENT_LOW_SPEED = 120
const CAMERA_MOVEMENT_NO_SPEED = 5

const SPEED_CHANGE_TIME = 0.25

var velocity = Vector2()
var speed = 0

var t = null
var start_speed = 0
var end_speed = 0

func _ready():
	position = Glb.get_racoon_spawn_point()

func _physics_process(delta):

	var raccoon = Glb.get_raccoon()
	var target_vector = Vector2()
	
	if raccoon != null:
		target_vector = get_enemy_center_position(raccoon.position + raccoon.direction * CAMERA_OFFSET)
	else:
		target_vector = Glb.get_racoon_spawn_point()

	target_vector = target_vector - position

	
	if target_vector.length_squared() > CAMERA_FAR:
		change_speed(CAMERA_MOVEMENT_TOP_SPEED)
	elif target_vector.length_squared() > CAMERA_CLOSE:
		change_speed(CAMERA_MOVEMENT_SPEED)
	elif target_vector.length_squared() > CAMERA_TOO_CLOSE:
		change_speed(CAMERA_MOVEMENT_LOW_SPEED)
	else:
		change_speed(CAMERA_MOVEMENT_NO_SPEED)
		if raccoon == null:
			Glb.at_spawn_point()
		

	velocity = speed * target_vector.normalized()
	

	
	position += velocity * delta

	if t != null:
		speed = lerp(start_speed, end_speed, t)
		t += delta / SPEED_CHANGE_TIME
		if t > 1:
			t = null


func change_speed(target_speed):
	if t != null:
		return
		
	start_speed = speed
	end_speed = target_speed 
	t = 0

func get_enemy_center_position(raccoon_pos):

	var fellas = get_tree().get_nodes_in_group("EnemyPilots")
	var planes = 2
	var new_pos = raccoon_pos + raccoon_pos
	if fellas.size() > 0:

		var i = 0
		while i < fellas.size():
			var data = fellas[i].get_camera_values()
			if (raccoon_pos - data.pos).length_squared() <= MIN_DISTANCE_TO_RACCOON_TO_ACCEPT_POS:
				new_pos += data.pos 
				planes += 1
			i += 1
	
	new_pos = new_pos / planes
		
	return new_pos
	
