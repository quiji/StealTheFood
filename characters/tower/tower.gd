extends Sprite

enum TowerMode {SWEEP_MODE, FOUND_MODE, ALERT_MODE, COOLDOWN_MODE, BACK_TO_DUTY_MODE}

signal raccoon_sighted
signal found_something

export (NodePath) var guard_target
export (float) var sweep_duration = 5.0
export (float) var back_to_duty_duration = 2.0
export (float) var cooldown_duration = 2.0
export (float) var found_duration = 2.0

var target = null
var target_end_angle = null
var target_start_angle = null

var back_to_duty_start_angle = 0
var back_to_duty_target_angle = 0

var t = 0
var direction = 1

var raccoon = null
var found_timer = 0
var cooldown_timer = 0
var mode

func _ready():
	
	add_to_group("Towers")
	
	if guard_target:
		target = get_node(guard_target).position - position
		var angle = target.angle()
		target_start_angle = angle - PI/2
		target_end_angle = angle + PI/2

	mode = SWEEP_MODE

func set_mode(new_mode):
	mode = new_mode
	if mode == SWEEP_MODE:
		$light_source.sweep_mode()
		
		$circle_light.enabled = false
		$tower_notices.hide()
		
	elif mode == ALERT_MODE:
		$light_source.alert_mode()

		$circle_light.enabled = true
		$tower_notices.show()
		$tower_notices/anim_player.play("Alert")

		emit_signal("raccoon_sighted")

	elif mode == FOUND_MODE:
		$light_source.found_mode()
		found_timer = found_duration

		emit_signal("found_something")

		$circle_light.enabled = true
		$tower_notices.show()
		$tower_notices/anim_player.play("Question")


	elif mode == COOLDOWN_MODE:
		$light_source.cool_down_mode()
		cooldown_timer = cooldown_duration
		
		$circle_light.enabled = true
		$tower_notices.show()
		if $tower_notices/anim_player.current_animation != "Question":
			$tower_notices/anim_player.play("Question")

		
	elif mode == BACK_TO_DUTY_MODE:

		$circle_light.enabled = false
		$tower_notices.hide()

		$light_source.sweep_mode()
		if target != null:
			back_to_duty_start_angle = $light_source.rotation
			back_to_duty_target_angle = target_start_angle
			t = 0

func pause_towering():
	set_physics_process(false)
	
	$circle_light.enabled = true
	$tower_notices.show()
	$tower_notices/anim_player.play("Alert")
	
	$light_source.hide()

func continue_towering():
	set_physics_process(true)

	$circle_light.enabled = false
	$tower_notices.hide()
	$light_source.show()
	
	set_mode(BACK_TO_DUTY_MODE)


func _physics_process(delta):

	var raccoon_found = false
	if raccoon != null:
		var ray_vector = raccoon.position - position
		$ray_cast.cast_to = ray_vector
		$ray_cast.force_raycast_update()
		
		if $ray_cast.is_colliding() and $ray_cast.get_collider().has_method("process_ai"):
			raccoon_found = true

	if raccoon_found:
		if mode == SWEEP_MODE or mode == COOLDOWN_MODE:
			set_mode(FOUND_MODE)
		elif mode == FOUND_MODE and found_timer > 0:
			found_timer -= delta
		elif mode == FOUND_MODE:
			set_mode(ALERT_MODE)
	elif mode == FOUND_MODE or mode == ALERT_MODE:
		set_mode(COOLDOWN_MODE)
	elif mode == COOLDOWN_MODE:
		if cooldown_timer > 0:
			cooldown_timer -= delta
		else:
			set_mode(BACK_TO_DUTY_MODE)
		


	if target != null and mode == SWEEP_MODE:
		t += delta / sweep_duration * direction
		
		if t > 1:
			t = 1
			direction = -1
		elif t < 0:
			t = 0
			direction = 1
			
		$light_source.rotation = lerp(target_start_angle, target_end_angle, Smoothstep.cross(t, Smoothstep.start3(t), Smoothstep.stop3(t)))
	
	elif raccoon != null and mode == FOUND_MODE or mode == ALERT_MODE:
		var ray_vector = raccoon.position - position
		$light_source.rotation = ray_vector.angle()
	
	elif mode == BACK_TO_DUTY_MODE:
		t += delta / back_to_duty_duration
		if t > 1:
			t = 0
			direction = 1
			set_mode(SWEEP_MODE)
		else:
			$light_source.rotation = lerp(back_to_duty_start_angle, back_to_duty_target_angle, Smoothstep.cross(t, Smoothstep.start3(t), Smoothstep.stop3(t)))

	
