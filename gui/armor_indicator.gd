extends Node2D

const SHIELD_OFFSET = Vector2(20, 0)

var shields = null
var healthy_shields = 0
func _ready():
	$swap_tween.connect("tween_completed", self, "on_tween_completed")

func set_shield_count(val):
	var next_pos = Vector2()
	
	if shields == null:
		shields = Node2D.new()
		
		var i = 0
		while i < val:
			var sprite = $demo.duplicate()
			sprite.position = next_pos
			shields.add_child(sprite)
			sprite.scale = Vector2(0.01, 0.01)
			sprite.show()
			$tween.interpolate_property(sprite, "scale", Vector2(0.01, 0.01), Vector2(1, 1), 0.8, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.15 * i)
			next_pos += SHIELD_OFFSET
			i += 1
		add_child(shields)
		$tween.start()
	else:
		var i = 0
		var j = 0
		while i < val:
			var sprite = shields.get_child(i)
			if sprite.frame != 0:
				sprite.scale = Vector2(0.01, 0.01)
				sprite.frame = 0
				$tween.interpolate_property(sprite, "scale", Vector2(0.01, 0.01), Vector2(1, 1), 0.8, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.15 * j)
				j += 1
			i += 1
		$tween.start()

	healthy_shields = val


func remove_shields(n):
	
	var i = 0
	while i < n and healthy_shields > 0:
		var sprite = shields.get_child(healthy_shields - 1)
		healthy_shields -= 1
		$swap_tween.interpolate_property(sprite, "scale", Vector2(1, 1), Vector2(0.01, 0.01), 0.2, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.15 * i)
		$swap_tween.start()
		i += 1


func add_shields(n):
	return 

func on_tween_completed(obj, key):
	if obj.frame == 0:
		obj.frame = 1
	else:
		obj.frame = 0
		
	$tween.interpolate_property(obj, "scale", Vector2(0.01, 0.01), Vector2(1, 1), 0.2, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$tween.start()
