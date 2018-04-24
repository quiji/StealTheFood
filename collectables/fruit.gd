extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	add_to_group("Fruits")
	connect("body_entered", self, "apple_eaten")
	

func apple_eaten(body):
	collision_mask = 0
	$apple.play()
	hide()
	Glb.apple_eaten()
	
	
func availible():
	collision_mask = 8
	show()

func unavailible():
	collision_mask = 0
	hide()
	



func _on_apple_finished():
	queue_free()
