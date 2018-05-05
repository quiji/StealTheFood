extends Node2D

var Gui = preload("res://gui/ingame_gui.tscn")
var CameraCrew = preload("res://gui/camera_crew.tscn")
var Maestro = preload("res://sound/maestro.tscn")
var EnemyPlane = preload("res://characters/enemy/enemy.tscn")
var Shadow = preload("res://sparks/plane_shadow.tscn")
var PlaneExplosion = preload("res://sparks/explosion.tscn")
var Raccoon = preload("res://characters/raccoon/raccoon.tscn")
var Fruit = preload("res://collectables/fruit.tscn")

enum GameModes {STEALTH, BATTLE_ROYALE}

export (int, "Stealth", "BattleRoyale") var game_mode = STEALTH

var camera_crew = null
var music_maestro = null
var gui = null
var modulate_node  = null
var tween = null
var enemy_timer = null

var alarm_count = 0

var raccoon = null

var enemy_planes = 0
var apple_count = 0
var apple = null


func _ready():

	
	tween = Tween.new()
	add_child(tween)
	
	modulate_node = CanvasModulate.new()
	modulate_node.color = Color("#656565")
	add_child(modulate_node)
	
	camera_crew = CameraCrew.instance()
	add_child(camera_crew)

	gui = Gui.instance()
	add_child(gui)
	gui.mode_change_completed_callback("mode_change_ready")
	
	
	enemy_timer = Timer.new()
	add_child(enemy_timer)
	enemy_timer.wait_time = 2.0
	enemy_timer.one_shot = true
	enemy_timer.connect("timeout", self, "enemy_spawn_moment")

	music_maestro = Maestro.instance()
	add_child(music_maestro)
	music_maestro.play_steal_the_thief()


	var towers = $battlefield.get_children()
	var i = 0
	while i < towers.size():
		if towers[i].has_method("pause_towering"):
			towers[i].connect("raccoon_sighted", self, "alert_mode_on")
			towers[i].connect("found_something", self, "found_something")
		i += 1

	"""
	var clouds = $clouds_high.get_children()
	i = 0
	while i < clouds.size():
		clouds[i].set_height(180)

		var shadow = Shadow.instance()
		$shadows.add_child(shadow)
		clouds[i].set_shadow(shadow)

		i += 1

	clouds = $clouds_medium.get_children()
	i = 0
	while i < clouds.size():
		clouds[i].set_height(140)
	
		var shadow = Shadow.instance()
		$shadows.add_child(shadow)
		clouds[i].set_shadow(shadow)
	
	
		i += 1

	clouds = $clouds_low.get_children()
	i = 0
	while i < clouds.size():
		clouds[i].set_height(100)
		
		var shadow = Shadow.instance()
		$shadows.add_child(shadow)
		clouds[i].set_shadow(shadow)

		
		i += 1
	"""

	alarm_count = 0

	apple_count = 0
	gui.update_score(apple_count, game_mode == BATTLE_ROYALE)


	spawn_raccoon()
	
	if game_mode == STEALTH:
		spawn_fruit()
	else:
		alert_mode_on()



func back_to_normal():
	music_maestro.stop_rookie_raccoon()

	
	tween.interpolate_property(modulate_node, "color", modulate_node.color, Color("#656565"), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

	get_tree().call_group("Towers", "continue_towering")


	gui.set_buggies(0)
	gui.change_mode(gui.INCOGNITO_MODE)


func move_to_layer(plane, layer):
	plane.get_parent().remove_child(plane)
	match layer:
		Glb.HIGH_LAYER:
			$high_layer.add_child(plane)
		Glb.MEDIUM_LAYER:
			$medium_layer.add_child(plane)
		Glb.LOW_LAYER:
			$low_layer.add_child(plane)
		_:
			$low_layer.add_child(plane)


func found_something():
	pass

func is_position_too_far(pos):
	return (pos - camera_crew.position).length_squared() > 1280 * 1280

func alert_mode_on():
	alarm_count += 1
	music_maestro.stop_steal_the_thief()
	
	tween.interpolate_property(modulate_node, "color", modulate_node.color, Color("#AAAAAA"), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	get_tree().call_group("Towers", "pause_towering")
	
	gui.set_buggies(alarm_count)
	gui.change_mode(gui.ALARM_MODE)
	

func mode_change_ready(mode):
	match mode:
		gui.INCOGNITO_MODE:
			music_maestro.resume_steal_the_thief()
			
			get_tree().call_group("Fruits", "availible")
			
		gui.ALARM_MODE:
			music_maestro.play_rookie_raccoon()
			enemy_planes = alarm_count
			enemy_timer.start()

			get_tree().call_group("Fruits", "unavailible")


func enemy_spawn_moment():
	if enemy_planes > 0:
		spawn_enemies()
		enemy_planes -= 1
		enemy_timer.start()



func spawn_enemies():
	
	var enemy = EnemyPlane.instance()
	enemy.position = $hangars/enemy_hangar.position
	$battlefield.add_child(enemy)

	var shadow = Shadow.instance()
	$shadows.add_child(shadow)
	enemy.set_shadow(shadow)


func spawn_raccoon():
	var shadow = Shadow.instance()
	$shadows.add_child(shadow)

	raccoon = Raccoon.instance()
	raccoon.position = $hangars/raccoon_hangar.position
	$battlefield.add_child(raccoon)
	raccoon.set_shadow(shadow)

func plane_explosion_at(pos):
	var explosion_particle = PlaneExplosion.instance()
	explosion_particle.position = pos

	$ground_layer.add_child(explosion_particle)
	explosion_particle.emitting = true

func spawn_fruit():
	
	if $fruit_location.get_child_count() > 0:
		var target_loc = randi() % $fruit_location.get_child_count()
		var apple = Fruit.instance()
		apple.position = $fruit_location.get_child(target_loc).position
		$fruit_location.add_child(apple)

func apple_eaten():
	apple_count += 1
	gui.update_score(apple_count)
	spawn_fruit()


func get_raccoon():
	return raccoon

func get_racoon_spawn_point():
	return $hangars/raccoon_hangar.position

func raccoon_failed():
	apple_count = 0
	gui.update_score(apple_count, game_mode == BATTLE_ROYALE)
	raccoon = null

func enemy_pilot_failed():
	var pilots = get_tree().get_nodes_in_group("EnemyPilots")
	gui.buggie_down()
	
	if game_mode == BATTLE_ROYALE:
		apple_count += 10
		gui.update_score(apple_count, true)

	if pilots.size() == 0 and game_mode == STEALTH:
		back_to_normal()
	elif pilots.size() == 0:
		alert_mode_on()

	

func set_shields(n):
	gui.set_shields(n)

func add_shields(n):
	gui.add_shields(n)

func remove_shields(n):
	gui.remove_shields(n)

func pause_menu_hidden():
	paused_game = false

var paused_game = false
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		paused_game = not paused_game
		gui.pause_menu(paused_game)
		
		get_tree().paused = paused_game


	if Input.is_action_just_pressed("call_air_force"):
		alert_mode_on()


