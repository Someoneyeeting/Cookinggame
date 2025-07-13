extends Node2D


var player : Player
var hovering : Area2D
var mouseprevpos := Vector2.ZERO
var isaiming := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
func _on_mouse_area_entered(area: Area2D) -> void:
	hovering = area
	
	if(area.is_in_group("targetable")):
		$target.global_position = area.global_position
	else:
		$target.global_position = Vector2(-100,-100)


func _on_mouse_area_exited(area: Area2D) -> void:
	if(hovering == area):
		hovering = null
	$target.global_position = Vector2(-100,-100)

func _input(event: InputEvent) -> void:
	if(isaiming):
		if(event.is_action_released("rightc")):
			if(hovering):
				if(hovering.is_in_group("targetable")):
					player.throw(hovering.get_parent())
					
			isaiming = false
	else:
		if(event.is_action_released("leftc")):
			if(hovering):
				if(hovering.is_in_group("podium")):
					player.add_food(hovering.get_parent())
				

func _process(delta: float) -> void:
	var mousemovedir = get_global_mouse_position() - mouseprevpos
	$mouse/cursor.rotation = lerp_angle($mouse/cursor.rotation,mousemovedir.angle() + 3.14/2,0.6 * mousemovedir.length() / 30)
	$mouse/cursor.rotation = lerp_angle($mouse/cursor.rotation,0,0.2)
	$mouse.global_position = get_global_mouse_position()
	mouseprevpos = $mouse.global_position
	
	if(Input.is_action_pressed("rightc")):
		isaiming = true
		Engine.time_scale = 0.4
	else:
		isaiming = false
		Engine.time_scale = 1
	
	$target.visible = isaiming
	
	$dark.color.a = lerp($dark.color.a, 0.3 if isaiming else 0.,0.08)
