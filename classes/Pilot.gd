extends KinematicBody2D

var Explosion = preload("res://sparks/explosion.tscn")
var Bullet = preload("res://bullets/bullet.tscn")
var ShootSpark = preload("res://sparks/shoot_light.tscn")

var stats = {
	top_speed = 180,
	shoot_burst = 0.18,
	lives = 3,
}

const BULLET_SPOT_DISTANCE = 40

enum MOVE_DIRECTIONS {MOVE_LEFT, MOVE_RIGHT}

var direction = Vector2(-1, 0)
var target_direction = null
var velocity = Vector2(-1, 0)

var shoot_burst_time = -1

var destroyed = false
var lives = 0

func _ready():
	if has_node("propeller"):
		$propeller/anim_player.play("Propel")

	if has_node("sprite"):
		$sprite/anim_player.play("Flying")
		$sprite/anim_player.connect("animation_finished", self, "on_animation_finished")

	configure()

	velocity *= stats.top_speed
	lives = stats.lives


func configure():
	pass

func process_ai(delta):
	pass
	
func pilot_failed():
	pass
	
func _physics_process(delta):
	if not destroyed:
		process_ai(delta)

	if target_direction != null and target_direction == MOVE_RIGHT:
		direction = (20 * direction - direction.tangent()).normalized()

	elif target_direction != null and target_direction == MOVE_LEFT:
		direction = (20 * direction + direction.tangent()).normalized()

		
	velocity = stats.top_speed * direction
	var collision_data = move_and_collide(velocity * delta)

	rotation = direction.angle()
	
	if collision_data != null and (collision_data.collider.has_method("plane_destroyed") or collision_data.collider.is_class("StaticBody2D")):
		if collision_data.collider.has_method("plane_destroyed"):
			collision_data.collider.plane_destroyed()
		plane_destroyed()
		direction = collision_data.normal

	if shoot_burst_time >= 0:
		shoot_burst_time -= delta

func plane_destroyed():
	if not destroyed:
		
		$plane_sounds.play_crash()
		
		if has_node("propeller"):
			$propeller.hide()
			
		if has_node("sprite"):
			$sprite/anim_player.play("Blasted")
		destroyed = true

func get_camera_values():
	return { pos = position}

func on_animation_finished(anim_name):
	if anim_name == "Blasted":
		var explosion_particle = Explosion.instance()
		explosion_particle.position = position

		get_parent().add_child(explosion_particle)
		explosion_particle.emitting = true
		
		pilot_failed()
		queue_free()

func shoot_bullet():
	if shoot_burst_time < 0:
		var spark = ShootSpark.instance()
		var bullet = Bullet.instance()
		var random_pos_factor = rand_range(-8, 8)
		bullet.position = position + direction * BULLET_SPOT_DISTANCE + direction.tangent() * random_pos_factor
		spark.position = Vector2(1, 0) * BULLET_SPOT_DISTANCE + Vector2(1, 0).tangent() * random_pos_factor
		add_child(spark)
		get_parent().add_child(bullet)
		bullet.shoot(direction)
		shoot_burst_time = stats.shoot_burst

func receive_bullet_damage():
	lives -= 1
	if lives == 2:
		$plane_smoke.emitting = true
		$plane_smoke.amount = 10
	elif lives == 1:
		$plane_smoke.emitting = true
		$plane_smoke.amount = 200
	elif lives <= 0:
		plane_destroyed()
