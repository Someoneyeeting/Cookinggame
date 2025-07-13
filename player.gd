extends CharacterBody2D
class_name Player

@export var move_speed : float = 200
@export var plate : Plate

func add_food(pod : Podium):
	if(pod.global_position.distance_to(global_position) > 200):
		return
	plate.add_ingridiant(pod.item)

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

	$Line2D.visible = Input.is_action_pressed("left?c")

func throw(target : Node2D):
	if(not plate.canthrow()):
		return
	
	target.get_thrown(plate.get_count())
	plate.clear()
	Partmanager.summon("break",target.global_position)
	draw_throw(target.global_position,plate.av_color())

func draw_throw(target : Vector2,clr : Color):
	$Line2D.points[0] = global_position
	$Line2D.points[1] = target
	$Line2D.default_color = clr
	
	$Line2D.show()
	$timers/line.start()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")):
		pass

func _physics_process(delta: float) -> void:
	Globals.player = self
	_handle_move()
	

	
	if(get_global_mouse_position().distance_to(global_position) < 200):
		$range.color.a = lerp($range.color.a,0.0,0.3)
	else:
		$range.color.a = lerp($range.color.a,0.4,0.3)
	
	$Line2D.points[0] =  lerp($Line2D.points[0],$Line2D.points[1],0.4)


func _on_line_timeout() -> void:
	$Line2D.hide()
