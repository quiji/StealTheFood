extends Node2D

const HEIGHT_DIVIDER = 2

func _ready():
	hide()


func set_sprite(spr):
	$sprite.texture = spr.texture
	$sprite.vframes = spr.vframes
	$sprite.hframes = spr.hframes

	$sprite.modulate = Color(0, 0, 0)
	

func update_shadow(pos, direction, plane_height, sprite_frame=null):
	if sprite_frame != null:
		$sprite.frame = sprite_frame
	
	rotation = direction.angle() + PI / 2
	position = pos
	

	"""
	var world = get_world_2d()
	if world != null:
		var space_rid = get_world_2d().space
		var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
		# 16 is bit 4 which is Clouds Layer
		var collider = null
		var collisions = space_state.intersect_point(position, 1, [], 16)

		if collisions.size() > 0:
			collider = collisions[0].collider
			
		else:
			var result = space_state.intersect_ray(position  + Vector2(0, (plane_height - 20) / HEIGHT_DIVIDER), position, [], 16)

			if not result.empty():
				collider = result.collider
	
	
		if collider != null:
			plane_height -= collider.get_height()
	"""

	position.y += plane_height / HEIGHT_DIVIDER + 16
	
	# shadow size depends on 180 of height
	
	var shadow_size = 1.0 - clamp(plane_height / 180.0, 0.3, 0.7)
	$sprite.scale = Vector2(shadow_size, shadow_size)
	
	# modulate depends of height too
	
	$sprite.modulate.a = shadow_size
	
	