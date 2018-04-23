extends Node2D

var CameraCrew = preload("res://gui/camera_crew.tscn")
var Maestro = preload("res://sound/maestro.tscn")
var EnemyPlane = preload("res://characters/enemy/enemy.tscn")
var Raccoon = preload("res://characters/raccoon/raccoon.tscn")


var camera_crew = null
var music_maestro = null
var modulate_node  = null
var tween = null
var respawn_timer = null

func _ready():
	$indicators/spawn_point.hide()
	
	respawn_timer = Timer.new()
	add_child(respawn_timer)
	respawn_timer.one_shot = true
	respawn_timer.wait_time = 2.0
	respawn_timer.connect("timeout", self, "on_respawn_time_up")
	
	tween = Tween.new()
	add_child(tween)
	
	modulate_node = CanvasModulate.new()
	modulate_node.color = Color("#656565")
	add_child(modulate_node)
	
	camera_crew = CameraCrew.instance()
	add_child(camera_crew)

	music_maestro = Maestro.instance()
	add_child(music_maestro)
	music_maestro.play_steal_the_thief()

	if has_node("towers"):
		var towers = $towers.get_children()
		var i = 0
		while i < towers.size():
			towers[i].connect("raccoon_sighted", self, "alert_mode_on")
			towers[i].connect("found_something", self, "found_something")
			i += 1

	spawn_raccoon()

func back_to_normal():
	
	music_maestro.transition_rookie_thief()
	
	tween.interpolate_property(modulate_node, "color", modulate_node.color, Color("#656565"), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

	get_tree().call_group("Towers", "continue_towering")


func found_something():
	pass

func is_bullet_too_far(pos):
	return (pos - camera_crew.position).length_squared() > 1500 * 1500

func alert_mode_on():
	music_maestro.transition_thief_rookie()
	
	tween.interpolate_property(modulate_node, "color", modulate_node.color, Color("#AAAAAA"), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	get_tree().call_group("Towers", "pause_towering")

	spawn_enemies()
	
func spawn_enemies():
	
	var spawn_location = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * 1000
	
	#var pos = camera_crew.position - Vector2(1280, 720) * 0.75
	var pos = camera_crew.position + spawn_location
	
	
	var enemy = EnemyPlane.instance()
	enemy.position = pos
	add_child(enemy)
	
func spawn_raccoon():
	var raccoon = Raccoon.instance()
	raccoon.position = $indicators/spawn_point.position
	raccoon.set_name("raccoon")
	add_child(raccoon)
	
func get_raccoon():
	if has_node("raccoon"):
		return $raccoon
	else:
		return null

func get_racoon_spawn_point():
	return $indicators/spawn_point.position

func raccoon_failed():
	pass
	#respawn_timer.start()

func enemy_pilot_failed():
	var pilots = get_tree().get_nodes_in_group("EnemyPilots")
	if pilots.size() == 0:
		back_to_normal()
	

func on_respawn_time_up():
	spawn_raccoon()

func _input(event):
	if Input.is_action_just_pressed("call_air_force"):
		alert_mode_on()
