extends Node2D

signal finished_showing

const PLANES_PER_ROW = 10

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

var plane_count = 0
var next_plane_pos = Vector2()
var y_offset_count = PLANES_PER_ROW

func show_count(val):
	
	$show_planes.wait_time = clamp(0.45 - 0.015 * val, 0.15, 0.45)
	
	plane_count = val
	next_plane_pos = Vector2()
	y_offset_count = PLANES_PER_ROW
	_on_show_timeout()


func _on_show_timeout():

	if y_offset_count < 1:
		y_offset_count = PLANES_PER_ROW
		next_plane_pos.y -= 22
		next_plane_pos.x = 0

	plane_count -= 1
	y_offset_count -= 1
	
	if plane_count >= 0:
		
		var sprite = $demo.duplicate()
		sprite.position = next_plane_pos
		next_plane_pos.x -= 24
		$planes.add_child(sprite)
		
		$tween.interpolate_property(sprite, "scale", Vector2(0.01, 0.01), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		$tween.start()
		sprite.show()
		
		$sounds.play_stamp()
		$show_planes.start()
	elif plane_count < 0:
		emit_signal("finished_showing")


func buggie_down():
	var children = $planes.get_children()
	
	if children.size() > 0:
		children[children.size() - 1].queue_free()


	
