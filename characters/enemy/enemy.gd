extends "res://classes/Pilot.gd"

enum ActionStates {FIND_TARGET, ATTACK, REGROUP}
enum SurvivalStates {NO_DANGER, THREAT_AHEAD}

var action_state
var survival_state

#Weak Stats
const WEAK_MINIMUM_DISTANCE_TO_REGROUP = 400
const WEAK_MAXIMUM_DISTANCE_TO_ATTACK = 300
const WEAK_MINIMUM_DISTANTE_TO_TARGET = 200

#Medium Stats
const MEDIUM_MINIMUM_DISTANCE_TO_REGROUP = 600
const MEDIUM_MAXIMUM_DISTANCE_TO_ATTACK = 450
const MEDIUM_MINIMUM_DISTANTE_TO_TARGET = 200

# Strong Stats
const STRONG_MINIMUM_DISTANCE_TO_REGROUP = 300
const STRONG_MAXIMUM_DISTANCE_TO_ATTACK = 500
const STRONG_MINIMUM_DISTANTE_TO_TARGET = 200


var REGROUP_DISTANCE = 0
var TARGET_DISTANCE = 0
var ATTACK_DISTANCE = 0

var disolve_threat_time = 0

func configure():
	stats.top_speed = 250
	add_to_group("EnemyPilots")
	
	match randi() % 3:
		0:
			REGROUP_DISTANCE = WEAK_MINIMUM_DISTANCE_TO_REGROUP * WEAK_MINIMUM_DISTANCE_TO_REGROUP
			TARGET_DISTANCE = WEAK_MINIMUM_DISTANTE_TO_TARGET * WEAK_MINIMUM_DISTANTE_TO_TARGET
			ATTACK_DISTANCE = WEAK_MAXIMUM_DISTANCE_TO_ATTACK * WEAK_MAXIMUM_DISTANCE_TO_ATTACK
		1:
			REGROUP_DISTANCE = WEAK_MINIMUM_DISTANCE_TO_REGROUP * WEAK_MINIMUM_DISTANCE_TO_REGROUP
			TARGET_DISTANCE = WEAK_MINIMUM_DISTANTE_TO_TARGET * WEAK_MINIMUM_DISTANTE_TO_TARGET
			ATTACK_DISTANCE = WEAK_MAXIMUM_DISTANCE_TO_ATTACK * WEAK_MAXIMUM_DISTANCE_TO_ATTACK
		2:
			REGROUP_DISTANCE = STRONG_MINIMUM_DISTANCE_TO_REGROUP * STRONG_MINIMUM_DISTANCE_TO_REGROUP
			TARGET_DISTANCE = STRONG_MINIMUM_DISTANTE_TO_TARGET * STRONG_MINIMUM_DISTANTE_TO_TARGET
			ATTACK_DISTANCE = STRONG_MAXIMUM_DISTANCE_TO_ATTACK * STRONG_MAXIMUM_DISTANCE_TO_ATTACK
			
	action_state = FIND_TARGET
	survival_state = NO_DANGER
	
	$plane_sounds.set_engine_sound_bus("EnemyEngine")

func pilot_failed():
	remove_from_group("EnemyPilots")
	Glb.enemy_pilot_failed()

func get_direction_from_normal(normal):
	var left_vector = direction.tangent()
	var right_vector = -left_vector
	
	var dot_left = left_vector.dot(normal)
	var dot_right = right_vector.dot(normal)
	
	if dot_left > dot_right:
		return MOVE_LEFT
	else:
		return MOVE_RIGHT

func process_ai(delta):

	if ($survival_ray.is_colliding() or $survival_ray_left.is_colliding() or $survival_ray_right.is_colliding()) and survival_state != THREAT_AHEAD:
		survival_state = THREAT_AHEAD
		disolve_threat_time = 0.2
		if $survival_ray_left.is_colliding():
			target_direction = MOVE_RIGHT
		elif $survival_ray_right.is_colliding():
			target_direction = MOVE_RIGHT
		else:
			target_direction = get_direction_from_normal($survival_ray.get_collision_normal())
	elif survival_state == THREAT_AHEAD:
		if disolve_threat_time > 0:
			disolve_threat_time -= delta
		else:
			survival_state = NO_DANGER
			action_state = REGROUP

	if survival_state == THREAT_AHEAD:
		Console.add_log("survival", "THREAT")
	else:
		Console.add_log("survival", "NO")

	var target = Glb.get_raccoon()

	if target != null and survival_state == NO_DANGER:
	
		var target_vector = (target.position - position)
		var raccoon_direction = target_vector.normalized()
		var raccoon_distance_squared = target_vector.length_squared()
	
		match action_state:
			REGROUP:
				if raccoon_distance_squared < REGROUP_DISTANCE:
					if raccoon_direction.dot(direction) < -0.5:
						target_direction = get_direction_from_normal(-raccoon_direction)
				else:
					action_state = FIND_TARGET
					
			ATTACK:
				if raccoon_direction.dot(direction) > 0.9:
					target_direction = null
					shoot_bullet()
				else:
					target_direction = get_direction_from_normal(raccoon_direction)
				
				if raccoon_distance_squared < TARGET_DISTANCE:
					action_state = REGROUP
				
			FIND_TARGET:
				if raccoon_direction.dot(direction) > 0.5:
					target_direction = null
				else:
					target_direction = get_direction_from_normal(raccoon_direction)
				
				if raccoon_distance_squared < ATTACK_DISTANCE:
					action_state = ATTACK
	

	