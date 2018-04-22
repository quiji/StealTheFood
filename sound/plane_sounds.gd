extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$tween.interpolate_property($engine, "volume_db", -80, -5, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()


func play_crash():
	$crash.play()

