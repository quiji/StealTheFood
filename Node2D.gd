extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$raccoon_plane/anim_player.play("Flying")
	$propeller/anim_player.play("Propel")
