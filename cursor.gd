extends Area2D


var mouseprevpos := Vector2.ZERO

func _process(delta: float) -> void:
	var mousemovedir = get_global_mouse_position() - mouseprevpos
	global_position = get_global_mouse_position()
	$cursor.rotation = lerp_angle($cursor.rotation,mousemovedir.angle() + 3.14/2,0.6 * mousemovedir.length() / 30)
	$cursor.rotation = lerp_angle($cursor.rotation,0,0.2)
	mouseprevpos = global_position
