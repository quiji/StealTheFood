extends Node


func _ready():
	randomize()



func get_raccoon():
	if get_tree().current_scene.has_node("raccoon"):
		return get_tree().current_scene.get_node("raccoon")
	else:
		return null


func get_racoon_spawn_point():
	return get_tree().current_scene.get_racoon_spawn_point()

func is_bullet_too_far(pos):
	if get_tree().current_scene.has_method("is_bullet_too_far"):
		return get_tree().current_scene.is_bullet_too_far(pos)
	else:
		return false

func at_spawn_point():
	get_tree().current_scene.spawn_raccoon()

func enemy_pilot_failed():
	return get_tree().current_scene.enemy_pilot_failed()

func raccoon_failed():
	return get_tree().current_scene.raccoon_failed()

