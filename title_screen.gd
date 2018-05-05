extends Node2D




func _input(event):
	
	if Input.is_action_just_pressed("shoot"):
		get_tree().change_scene("res://levels/level_00.tscn")

	if Input.is_action_just_pressed("item"):
		get_tree().change_scene("res://levels/battle_royale.tscn")
		
		
