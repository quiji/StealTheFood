extends Node2D

enum SongNames {ROOKIE_RACCOON, STEAL_THE_THIEF}

var rookie_valid_intro = false
var playing

func _ready():
	$rookie_raccoon_intro.connect("finished", self, "on_rookie_intro_finished")

func play_steal_the_thief():
	$steal_the_thief.play()
	playing = STEAL_THE_THIEF
	
func on_rookie_intro_finished():
	if rookie_valid_intro:
		$rookie_raccoon.play()
		rookie_valid_intro = false
	
func stop_steal_the_thief():
	$steal_the_thief.stop()
	
func play_rookie_raccoon():
	if playing == ROOKIE_RACCOON:
		return
	playing = ROOKIE_RACCOON
	$rookie_raccoon_intro.play()
	rookie_valid_intro = true

func stop_rookie_raccoon():
	rookie_valid_intro = false
	$rookie_raccoon_intro.stop()
	$rookie_raccoon.stop()
	

func resume_steal_the_thief():
	$steal_the_thief.play(44.937)

	