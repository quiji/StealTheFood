extends Area2D

var height = 180
var shadow_node = null

func _ready():
	connect("body_entered", self, "on_plane_over")
	connect("body_exited", self, "on_plane_off")


func set_height(h):
	height = h

func on_plane_over(body):
	if body.has_method("over_cloud"):
		body.over_cloud(height)



func on_plane_off(body):
	if body.has_method("off_cloud"):
		body.off_cloud(height)
	

func get_height():
	return height
	

func set_shadow(shadow):
	shadow_node = shadow
	shadow_node.set_sprite($sprite)
	shadow_node.update_shadow(position, Vector2(0, -1), height)
