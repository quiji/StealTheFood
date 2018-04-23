extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$tween.interpolate_property($engine, "volume_db", -80, 0, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()


func set_engine_sound_bus(bus_name):
	$engine.bus = bus_name

func play_crash():
	$crash.play()

