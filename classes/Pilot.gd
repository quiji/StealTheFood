extends KinematicBody2D


var Bullet = preload("res://bullets/bullet.tscn")
var ShootSpark = preload("res://sparks/shoot_light.tscn")

var stats = {
	top_speed = 180,
	shoot_burst = 0.18,
	armor = 3,
}

const BULLET_SPOT_DISTANCE = 40
const COLLISION_INMUNITY_DURATION = 0.15
const GRAVITY = 98
enum MOVE_DIRECTIONS {MOVE_LEFT, MOVE_RIGHT}

var direction = Vector2(-1, 0)
var target_direction = null
var velocity = Vector2(-1, 0)

var shoot_burst_time = -1
var is_left_gun_last_shooted = false
var destroyed = false
var armor = 0
var collision_inmunity = null

var shadow_node = null

var height = 200


func _ready():
	if has_node("propeller"):
		$propeller.hide()
		$propeller/anim_player.play("Propel")

	if has_node("sprite"):
		$sprite/anim_player.play("Flying")
		$sprite/anim_player.connect("animation_finished", self, "on_animation_finished")

	configure()

	velocity *= stats.top_speed
	armor = stats.armor


func configure():
	pass

func process_ai(delta):
	pass
	
func pilot_failed():
	pass
	
func on_damage_received(n):
	pass

	
func _physics_process(delta):
	if not destroyed:
		process_ai(delta)

	if target_direction != null and target_direction == MOVE_RIGHT:
		direction = (20 * direction - direction.tangent()).normalized()

	elif target_direction != null and target_direction == MOVE_LEFT:
		direction = (20 * direction + direction.tangent()).normalized()

	
	if not destroyed:
		velocity = stats.top_speed * direction
		var collision_data = move_and_collide(velocity * delta)
	
		rotation = direction.angle()
	
		if collision_data != null and (collision_data.collider.has_method("plane_destroyed") or collision_data.collider.is_class("StaticBody2D")) and collision_inmunity == null:
			collision_inmunity = COLLISION_INMUNITY_DURATION
			#plane_destroyed()
			$plane_sounds.play_crash()
			receive_collision_damage()
			direction = collision_data.normal
	elif height > 0:
		var fall_motion = GRAVITY * delta
		height -= fall_motion
		if height < 0:
			height = 0

		move_and_collide(Vector2(0, fall_motion))
		


	if shoot_burst_time >= 0:
		shoot_burst_time -= delta
	
	if collision_inmunity != null:
		collision_inmunity -= delta
		if collision_inmunity < 0:
			collision_inmunity = null

	if shadow_node != null:
		if Glb.is_position_too_far(position):
			shadow_node.hide()
		else:
			shadow_node.update_shadow(position, direction, height, $sprite/sprite.frame)
			shadow_node.show()

func over_cloud(cloud_height):
	#shadow_height = height - cloud_height
	pass
	
func off_cloud(cloud_height):
	#shadow_height = height
	pass

func set_shadow(shadow):
	shadow_node = shadow
	shadow_node.set_sprite($sprite/sprite)
	shadow_node.update_shadow(position, direction, height, $sprite/sprite.frame)

func plane_destroyed():
	if not destroyed:
		
		Glb.move_to_layer(self, Glb.HIGH_LAYER)
		
		$plane_sounds.play_crash()
		
		collision_mask = 0
		collision_layer = 0
		
		if has_node("propeller"):
			$propeller.hide()
			
		if has_node("sprite"):
			$sprite/anim_player.play("Blasted")


		destroyed = true

func get_camera_values():
	return { pos = position}

func on_animation_finished(anim_name):
	if anim_name == "Blasted":
		if not Glb.is_position_too_far(position):
			Glb.plane_explosion_at(position)


		if shadow_node != null:
			shadow_node.queue_free()
		pilot_failed()
		queue_free()

func shoot_bullet():
	if shoot_burst_time < 0 and not destroyed:
		var spark = ShootSpark.instance()
		var bullet = Bullet.instance()
		var gun_pos = 8
		if not is_left_gun_last_shooted: 
			is_left_gun_last_shooted = true
			gun_pos = -8
		else:
			is_left_gun_last_shooted = false

		var random_pos_factor = rand_range(-4, 4) + gun_pos

		bullet.position = position + direction * BULLET_SPOT_DISTANCE + direction.tangent() * random_pos_factor
		spark.position = Vector2(1, 0) * BULLET_SPOT_DISTANCE + Vector2(1, 0).tangent() * random_pos_factor
		add_child(spark)
		get_parent().add_child(bullet)
		bullet.shoot(direction)
		shoot_burst_time = stats.shoot_burst

func receive_bullet_damage():
	armor -= 1
	on_damage_received(1)
	review_armor_damage()

func receive_collision_damage():
	armor -= 2
	on_damage_received(2)
	review_armor_damage()


func review_armor_damage():
	if armor == 2 and stats.armor > 2:
		$plane_smoke.emitting = true
		$plane_smoke.amount = 10
	elif armor == 1:
		$plane_smoke.emitting = true
		$plane_smoke.amount = 200
	elif armor <= 0:
		$plane_smoke.emitting = false
		plane_destroyed()

	