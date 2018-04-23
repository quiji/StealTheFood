extends KinematicBody2D

var BulletExplosion = preload("res://sparks/shoot_explosion.tscn")

const SPEED = 460

var direction = Vector2(1, 0)

func _ready():
	add_to_group("Bullets")
	$sprite/anim_player.play("Default")
	
	$sounds.connect("hit_finished", self, "on_hit_finished")

func shoot(dir):
	rotation = dir.angle()
	direction = dir
	$sounds.play_shoot()

func _physics_process(delta):
	
	var collision_data = move_and_collide(SPEED * direction * delta)
	
	if collision_data != null:
		var explosion = BulletExplosion.instance()
		explosion.position = position
		explosion.rotation = collision_data.normal.angle()
		get_parent().add_child(explosion)
		hide()
		collision_layer = 0
		collision_mask = 0
		$sounds.play_hit()

		
		if collision_data.collider.has_method("receive_bullet_damage"):
			collision_data.collider.receive_bullet_damage()

		set_physics_process(false)
	
	elif Glb.is_bullet_too_far(position):
		queue_free()
	

func on_hit_finished():
	queue_free()
