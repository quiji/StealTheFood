extends Node2D

var CameraCrew = preload("res://gui/camera_crew.tscn")

var camera_crew = null

func _ready():
	var modulate_node = CanvasModulate.new()
	modulate_node.color = Color("#656565")
	add_child(modulate_node)
	
	camera_crew = CameraCrew.instance()
	add_child(camera_crew)

