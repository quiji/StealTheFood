extends Area2D

var raccoon = null

func _ready():
	connect("body_entered", self, "on_raccoon_close")
	connect("body_exited", self, "on_raccoon_far")

func on_raccoon_close(body):
	get_parent().raccoon = body

func on_raccoon_far(body):
	get_parent().raccoon = null
	