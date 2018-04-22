extends KinematicBody2D

var BulletExplosion = preload("res://sparks/shoot_explosion.tscn")

const SPEED = 450

var direction = Vector2(1, 0)

func _ready():
	$sprite/anim_player.play("Default")

func shoot(dir):
	rotation = dir.angle()
	direction = dir
	$shoot.play()

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
		$ground_hit.play()
		"""
		if collision_data.collider.has_method("process_ai"):
			$ground_hit.play()
		else:
			$metal_hit.play()
		"""
		set_physics_process(false)
		
	

func _on_metal_hit_finished():
	queue_free()


func _on_ground_hit_finished():
	queue_free()
