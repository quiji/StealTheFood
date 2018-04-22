extends Particles2D

func _ready():
	$tween.interpolate_property($light, "energy", 3.5, 0, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN)
	$tween.start()

	
func _on_timer_timeout():
	if not emitting:
		queue_free()

