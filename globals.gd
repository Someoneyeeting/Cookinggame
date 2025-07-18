extends Node2D

signal eat(ids)
signal unhide_stuff

var player : Player
var lefthovering : Area2D
var righthovering : Targetable
var mouseprevpos := Vector2.ZERO
var isaiming := false
var isintro := true

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
		%mouse/cursor.scale = Vector2(0.025,0.025)
	elif(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		%mouse/cursor.scale = Vector2(0.015,0.015)
	

func start_music():
	$musicplay.start()

func _on_mouse_area_exited(area: Area2D) -> void:
	if(lefthovering == area):
		lefthovering = null
	if(righthovering == area):
		righthovering = null
	%target.global_position = Vector2(-100,-100)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("restart")):
		reset()
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
	%mouse.global_position = get_global_mouse_position()
	%mouse/cursor.rotation = lerp_angle(%mouse/cursor.rotation,mousemovedir.angle() + 3.14/2,0.6 * mousemovedir.length() / 30)
	%mouse/cursor.rotation = lerp_angle(%mouse/cursor.rotation,0,0.2)
	mouseprevpos = %mouse.global_position


	if(Input.is_action_pressed("rightc")):
		isaiming = true
		Engine.time_scale = 0.4
		#$music.volume_db = lerp($music.volume_db,-10.,0.1)
		#$music.pitch_scale = lerp($music.pitch_scale,1.,0.1)
	else:
		isaiming = false
		Engine.time_scale = 1
		#$music.volume_db = lerp($music.volume_db,-3.,0.5)
		#$music.pitch_scale = lerp($music.pitch_scale,1.,0.1)
	
	%target.visible = isaiming
	
	if(righthovering):
		%target.global_position = righthovering.global_position
	
	%dark.color.a = lerp(%dark.color.a, 0.3 if isaiming else 0.,0.08)
	
	if(not lefthovering or not righthovering):
		for i in %mouse.get_overlapping_areas():
			if(i is Targetable and not righthovering):
				righthovering = i
			elif(i.is_in_group("podium") and not lefthovering):
				lefthovering = i

func get_served():
	return %ScoreManager.get_served()

func _served(recp : RecipeRes):
	increase_served()

func increase_served():
	%ScoreManager.increase_served()

func shake(dir : Vector2):
	$Camera2D.position += dir
	$shake.start()


func _on_shake_timeout() -> void:
	$Camera2D.position = Vector2.ZERO


func change_hunger(amount : float):
	%ScoreManager.change_hunger(amount)
	
func set_hunger(amount : float):
	%ScoreManager.set_hunger(amount)
	
func _eat(ids):
	if(ids == [-1]):
		change_hunger(60)
	else:
		eat.emit(ids)
		change_hunger(20)
		
func add_star():
	%ScoreManager.add_star()

func lose_star():
	%ScoreManager.lose_star()


func _on_musicplay_timeout() -> void:
	$music.play()

func get_hunger_level():
	return %ScoreManager.get_hunger_level()

func get_hunger():
	return %ScoreManager.get_hunger()


func get_max_hunger():
	return %ScoreManager.get_max_hunger()


func music_loop() -> void:
	if(randi_range(0,70) == 0):
		$musicfreedom.play()
	else:
		$music.play()

func set_money(money : int):
	%ScoreManager.set_money(money)

func add_money(money : int):
	%ScoreManager.add_money(money)

func mult_stars(node : Node2D):
	await get_tree().create_timer(0.5).timeout
	%ScoreManager.mult_stars(node)

func add_actual_money(amount : int):
	%ScoreManager.add_actual_money(amount)

func show_hunger():
	%ScoreManager.show_hunger()

func lose():
	%losescreen.show()
	$music.stop()
	$musicfreedom.stop()

func restart():
	reset()

func reset():
	start_music()
	isintro = false
	set_hunger(60)
	%ScoreManager.set_stars(5)
	%losescreen.hide()
	get_tree().reload_current_scene()
