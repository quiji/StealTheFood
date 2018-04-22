extends Particles2D

func _ready():
	$tween.interpolate_property($light, "energy", 3.5, 0.01, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()
	
	emitting = true

func _on_timer_timeout():
	if not emitting:
		queue_free()
