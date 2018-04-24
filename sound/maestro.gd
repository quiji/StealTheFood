extends Node2D

var rookie_valid_intro = false

func _ready():
	$rookie_raccoon_intro.connect("finished", self, "on_rookie_intro_finished")

func play_steal_the_thief():
	$steal_the_thief.play()
	
func on_rookie_intro_finished():
	if rookie_valid_intro:
		$rookie_raccoon.play()
		rookie_valid_intro = false
	
func stop_steal_the_thief():
	$steal_the_thief.stop()
	
func play_rookie_raccoon():
	$rookie_raccoon_intro.play()
	rookie_valid_intro = true

func stop_rookie_raccoon():
	rookie_valid_intro = false
	$rookie_raccoon_intro.stop()
	$rookie_raccoon.stop()
	

func resume_steal_the_thief():
	$steal_the_thief.play(44.937)

	