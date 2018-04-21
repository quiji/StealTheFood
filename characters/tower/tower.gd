extends Sprite

export (NodePath) var guard_target
export (float) var sweep_duration = 5.0

var target = null
var target_end_angle = null
var target_start_angle = null

var t = 0
var direction = 1

var raccoon = null

func _ready():
	
	if guard_target:
		target = get_node(guard_target).position - position
		var angle = target.angle()
		target_start_angle = angle - PI/2
		target_end_angle = angle + PI/2


func _physics_process(delta):
	
	if target != null:
		t += delta / sweep_duration * direction
		
		if t > 1:
			t = 1
			direction = -1
		elif t < 0:
			t = 0
			direction = 1
			
		$light_source.rotation = lerp(target_start_angle, target_end_angle, Smoothstep.cross(t, Smoothstep.start3(t), Smoothstep.stop3(t)))
		
		
	if raccoon != null:
		var ray_vector = raccoon.position - position
		$ray_cast.cast_to = ray_vector
		$ray_cast.force_raycast_update()
		
		if $ray_cast.is_colliding():
			Console.add_log("Colliding", $ray_cast.get_collider())