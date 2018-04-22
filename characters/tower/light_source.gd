extends Area2D

var raccoon = null

func _ready():
	connect("body_entered", self, "on_raccoon_close")
	connect("body_exited", self, "on_raccoon_far")

func on_raccoon_close(body):
	get_parent().raccoon = body

func on_raccoon_far(body):
	get_parent().raccoon = null
	
func sweep_mode():
	$tween.interpolate_property($light, "energy", $light.energy, 1.4, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($light, "color", $light.color, Color("#ffffff"), 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()

func found_mode():
	$tween.interpolate_property($light, "energy", $light.energy, 2.5, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($light, "color", $light.color, Color("#daca28"), 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()

func alert_mode():
	$tween.interpolate_property($light, "energy", $light.energy, 3, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($light, "color", $light.color, Color("#da2828"), 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()

func cool_down_mode():
	$tween.interpolate_property($light, "energy", $light.energy, 2.5, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.interpolate_property($light, "color", $light.color, Color("#daca28"), 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()

