extends Node2D


func _ready():
	
	$tween.connect("tween_completed", self, "on_tween_completed")
	$tween.interpolate_property($light, "energy", 4, 0.01, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()


func on_tween_completed(obj, key):
	queue_free()

