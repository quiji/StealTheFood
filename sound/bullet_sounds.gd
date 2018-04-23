extends Node2D

signal hit_finished

func _ready():
	$hit.connect("finished", self, "hit_finished")

func hit_finished():
	emit_signal("hit_finished")
	
func play_shoot():
	$shoot.play()
	
func play_hit():
	$hit.play()

