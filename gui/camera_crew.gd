extends Node2D


func _physics_process(delta):

	var fellas = get_tree().get_nodes_in_group("FlyingFellas")
	
	if fellas.size() > 0:
		var new_pos = Vector2()
		var i = 0
		while i < fellas.size():
			var data = fellas[i].get_camera_values()
			new_pos += data.pos * data.camera_points
			i += 1
		new_pos = new_pos / fellas.size()
		
		position = new_pos
