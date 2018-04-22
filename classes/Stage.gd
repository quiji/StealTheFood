extends Node2D

var CameraCrew = preload("res://gui/camera_crew.tscn")
var EnemyPlane = preload("res://characters/enemy/enemy.tscn")


var camera_crew = null
var modulate_node  = null
var tween = null

func _ready():
	tween = Tween.new()
	add_child(tween)
	
	modulate_node = CanvasModulate.new()
	modulate_node.color = Color("#656565")
	add_child(modulate_node)
	
	camera_crew = CameraCrew.instance()
	add_child(camera_crew)

	if has_node("towers"):
		var towers = $towers.get_children()
		var i = 0
		while i < towers.size():
			towers[i].connect("raccoon_sighted", self, "alert_mode_on")
			towers[i].connect("found_something", self, "found_something")
			i += 1
		

func back_to_normal():
	
	tween.interpolate_property(modulate_node, "color", modulate_node.color, Color("#656565"), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

	get_tree().call_group("Towers", "continue_towering")


func found_something():
	pass


func alert_mode_on():
	tween.interpolate_property(modulate_node, "color", modulate_node.color, Color("#AAAAAA"), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	get_tree().call_group("Towers", "pause_towering")

	spawn_enemies()
	
func spawn_enemies():
	
	var pos = camera_crew.position - Vector2(1280, 720) * 0.75
	
	var enemy = EnemyPlane.instance()
	enemy.position = pos
	add_child(enemy)
	
func get_raccoon():
	if has_node("raccoon"):
		return $raccoon
	else:
		return null