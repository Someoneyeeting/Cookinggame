extends CharacterBody2D
class_name Player

@export var move_speed : float = 200

func add_food():
	$plate.add_ingridiant()

func _handle_move():
	var dir : Vector2 = Vector2.ZERO
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	dir = dir.normalized()
	
	if(dir.length() == 0):
		velocity = lerp(velocity,Vector2.ZERO,0.2)
	else:
		var sprint = Input.is_action_pressed("sprint")
		velocity = lerp(velocity,dir * move_speed * (1.6 if sprint else 1),0.09)
	
	
	move_and_slide()

func _handle_throw():
	$Line2D.points[0] = global_position
	$Line2D.points[1] = get_global_mouse_position()

	$Line2D.visible = Input.is_action_pressed("leftc")

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")):
		pass

func _physics_process(delta: float) -> void:
	Globals.player = self
	_handle_move()
	_handle_throw()
