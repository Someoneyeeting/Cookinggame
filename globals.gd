extends Node2D

signal eat(ids)

var player : Player
var lefthovering : Area2D
var righthovering : Targetable
var mouseprevpos := Vector2.ZERO
var isaiming := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
func _on_mouse_area_entered(area: Area2D) -> void:
	if(area is Targetable):
		righthovering = area
	if(area.is_in_group("podium")):
		lefthovering = area
	
	if(area.is_in_group("targetable")):
		%target.global_position = area.global_position
		if(isaiming):
			$target.play()
			
	else:
		%target.global_position = Vector2(-100,-100)

func toggle_fullscreen():
	if(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$mouse/cursor.scale = Vector2(0.025,0.025)
	elif(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$mouse/cursor.scale = Vector2(0.015,0.015)
	

func _on_mouse_area_exited(area: Area2D) -> void:
	if(lefthovering == area):
		lefthovering = null
	if(righthovering == area):
		righthovering = null
	%target.global_position = Vector2(-100,-100)

func _input(event: InputEvent) -> void:
	if(isaiming):
		if(event.is_action_released("rightc")):
			if(righthovering):
				player.throw(righthovering.target)
					
			isaiming = false
	else:
		if(event.is_action_released("leftc")):
			if(lefthovering):
				player.add_food(lefthovering.get_parent())
	
	if(event.is_action_pressed("fullscreen")):
		toggle_fullscreen()
				

func _process(delta: float) -> void:
	var mousemovedir = get_global_mouse_position() - mouseprevpos
	$mouse.global_position = get_global_mouse_position()
	$mouse/cursor.rotation = lerp_angle($mouse/cursor.rotation,mousemovedir.angle() + 3.14/2,0.6 * mousemovedir.length() / 30)
	$mouse/cursor.rotation = lerp_angle($mouse/cursor.rotation,0,0.2)
	mouseprevpos = $mouse.global_position
	
	if(Input.is_action_pressed("rightc")):
		isaiming = true
		Engine.time_scale = 0.4
	else:
		isaiming = false
		Engine.time_scale = 1
	
	%target.visible = isaiming
	
	if(righthovering):
		%target.global_position = righthovering.global_position
	
	%dark.color.a = lerp(%dark.color.a, 0.3 if isaiming else 0.,0.08)

func shake(dir : Vector2):
	$Camera2D.position += dir
	$shake.start()


func _on_shake_timeout() -> void:
	$Camera2D.position = Vector2.ZERO


func change_hunger(amount : float):
	$ScoreManager.change_hunger(amount)
	
func set_hunger(amount : float):
	$ScoreManager.set_hunger(amount)
	
func _eat(ids):
	if(ids == [-1]):
		change_hunger(50)
	else:
		eat.emit(ids)
		change_hunger(10)
		
func add_star():
	$ScoreManager.add_star()

func lose_star():
	$ScoreManager.lose_star()
