extends Node2D

func play_explosion():
	$explosion.play()

func is_explosion_playing():
	return $explosion.playing