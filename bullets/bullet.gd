extends KinematicBody2D

const SPEED = 450

var direction = Vector2(1, 0)

func _ready():
	$sprite/anim_player.play("Default")

func shoot(dir):
	rotation = dir.angle()
	direction = dir

func _physics_process(delta):
	
	var collision_data = move_and_collide(SPEED * direction * delta)
	
	if collision_data != null:
		queue_free()
	