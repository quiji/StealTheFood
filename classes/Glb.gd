extends Node


enum AltitudeLayers {HIGH_LAYER, MEDIUM_LAYER, LOW_LAYER}

func _ready():
	randomize()



func get_raccoon():
	return get_tree().current_scene.get_raccoon()


func get_racoon_spawn_point():
	return get_tree().current_scene.get_racoon_spawn_point()

func is_position_too_far(pos):
	if get_tree().current_scene.has_method("is_position_too_far"):
		return get_tree().current_scene.is_position_too_far(pos)
	else:
		return false

func at_spawn_point():
	get_tree().current_scene.spawn_raccoon()

func enemy_pilot_failed():
	return get_tree().current_scene.enemy_pilot_failed()

func raccoon_failed():
	return get_tree().current_scene.raccoon_failed()

func set_shields(n):
	get_tree().current_scene.set_shields(n)

func add_shields(n):
	get_tree().current_scene.add_shields(n)

func remove_shields(n):
	get_tree().current_scene.remove_shields(n)

func apple_eaten():
	get_tree().current_scene.apple_eaten()

func plane_explosion_at(pos):
	get_tree().current_scene.plane_explosion_at(pos)

func move_to_layer(plane, layer):
	get_tree().current_scene.move_to_layer(plane, layer)


############################################################################################################
#
#   Game Data
#
############################################################################################################

var apple_count = 0
var raccoon_lives = 3

func get_raccoon_lives():
	return raccoon_lives



