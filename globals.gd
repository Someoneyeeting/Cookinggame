extends Node2D


var player : Player
var hovering : Area2D
var mouseprevpos := Vector2.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
func _on_mouse_area_entered(area: Area2D) -> void:
	hovering = area
	
	if(area.is_in_group("customer")):
		$target.show()
		$target.global_position = area.get_parent().global_position
	else:
		$target.hide()


func _on_mouse_area_exited(area: Area2D) -> void:
	if(hovering == area):
		hovering = null
	$target.hide()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("leftc")):
		if(hovering):
			if(hovering.is_in_group("podium")):
				player.add_food()
				
	if(event.is_action_released("leftc")):
		if(hovering):
			if(hovering.is_in_group("customer")):
				hovering.get_parent().out()

func _process(delta: float) -> void:
	var mousemovedir = get_global_mouse_position() - mouseprevpos
	$mouse/cursor.rotation = lerp_angle($mouse/cursor.rotation,mousemovedir.angle() + 3.14/2,0.6 * mousemovedir.length() / 30)
	$mouse/cursor.rotation = lerp_angle($mouse/cursor.rotation,0,0.2)
	$mouse.global_position = get_global_mouse_position()
	mouseprevpos = $mouse.global_position
