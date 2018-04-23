extends Node2D

func _ready():
	$rookie_raccoon_intro.connect("finished", self, "on_rookie_intro_finished")

func play_steal_the_thief():
	$steal_the_thief.play()
	
func on_rookie_intro_finished():
	$rookie_raccoon.play()
	

func transition_thief_rookie():
	$steal_the_thief.stop()
	$rookie_raccoon_intro.play()

func transition_rookie_thief():
	if $rookie_raccoon_intro.playing:
		$rookie_raccoon_intro.stop()
	else:
		$rookie_raccoon.stop()
	$steal_the_thief.play(44.937)

	