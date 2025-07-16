extends CharacterBody2D
class_name Player

@export var move_speed : float = 200
@export var plate : Plate
@onready var markerpos :Vector2= $PlayerBase/Marker2D.position 
var t : float = 0

func add_food(obj):
	if(obj is Podium):
		add_food_pod(obj)
	if(obj is Oven):
		take_food_oven(obj)

func add_food_pod(pod : Podium):
	if(pod.global_position.distance_to(global_position) >= 200):
		return
	if(plate.can_add_item(pod.item)):
		plate.add_ingridiant(pod.item)
		pod.pick_up()
	else:
		$cantpick.play()

func take_food_oven(oven : Oven):
	if(plate.items.size() > 0):
		oven.get_thrown(plate.items)
	else:
		oven.open()
	plate.set_items(oven.replace_content(plate.items))

func _handle_move():
	var dir : Vector2 = Vector2.ZERO
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	dir = dir.normalized()
	
	if(dir.length() == 0):
		velocity = lerp(velocity,Vector2.ZERO,0.2)
		$sprint.emitting = false
		$walk.stop()
	else:
		var sprint = Input.is_action_pressed("sprint")
		velocity = lerp(velocity,dir * move_speed * (1.3 if sprint else 1),0.12)
		if(not $walk.playing):
			$walk.play()
		if(sprint):
			Globals.change_hunger(-0.1)
		else:
			Globals.change_hunger(-0.05)
		$sprint.emitting = sprint
	
	$walk.volume_db = lerp(-40,-20,velocity.length() / 350)
	$GPUParticles2D.rotation = -dir.angle()
	$GPUParticles2D.emitting = velocity.length() > 10
	
	$ColorRect.material.set_shader_parameter("skew",velocity.x / 100)
	$reflect.material.set_shader_parameter("skew",velocity.x / 100)
	
	$face.frame = Globals.get_hunger_level()
	$face.global_position = $PlayerBase/Marker2D.global_position - velocity * 0.03

	
	var rot : float = 0
	if(Globals.get_hunger_level() == 2):
		rot = t * 15
		var rand := randf_range(0.8,1.1)
		$face.modulate = Color(rand,rand,rand)
	else:
		rot = deg_to_rad(dir.x * -10)
		$face.modulate = Color(1,1,1)
	$face.rotation = lerp_angle($face.rotation,rot,0.3)
	if(Globals.get_hunger_level() == 0):
		$face.global_position.x += randf_range(-1,1) * 5
		$PlayerBase.modulate = lerp($PlayerBase.modulate,Color(Color(0.8,0.2,0.2),$PlayerBase.modulate.a),0.07)
		#$face.modulate = lerp($face.modulate,Color.RED,0.07)
		if(not $panic.playing):
			$panic.play()
	else:
		$panic.stop()
		$PlayerBase.modulate = lerp($PlayerBase.modulate,Color(Color.WHITE,$PlayerBase.modulate.a),0.07)
		#$face.modulate = lerp($face.modulate,Color.WHITE,0.07)
		
	
	
	move_and_slide()

func throw(target : Node2D):
	if(not plate.canthrow()):
		return

	var dir = global_position.direction_to(target.global_position)
	if(dir.length() == 0):
		Globals.shake(Vector2(10,10))
	else:
		Globals.shake(dir * 20)
		Globals.change_hunger(-10)
		
	if(plate.has_chicken):
		if(target is Oven):
			$chicken_echo.play()
		else:
			$chicken.play()
		
	target.get_thrown(plate.items)
	if(plate.is_poison()):
		Partmanager.summon("poison",target.global_position)
	else:
		if(target is not Oven):
			Partmanager.summon("break",target.global_position)
	
	if(target is Oven):
		plate.set_items(target.replace_content(plate.items))
	else:
		plate.clear()
	$break.pitch_scale = randf_range(0.85,1.2)
	$break.play()
	draw_throw(target.global_position,plate.av_color())
	

func draw_throw(target : Vector2,clr : Color):
	$Line2D.points[0] = plate.global_position
	$Line2D.points[1] = target
	
	$Line2D.show()
	$timers/line.start()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")):
		pass

func get_thrown(items : Array[ItemRes]):
	var ids = []
	for i in items:
		ids.push_back(i.id)
	Globals._eat(ids)

func _physics_process(delta: float) -> void:
	Globals.player = self
	_handle_move()
	
	t += delta
	
	var mpos := markerpos + markerpos.direction_to(get_global_mouse_position() - $PlayerBase.global_position) * 3
	$PlayerBase/Marker2D.position = lerp($PlayerBase/Marker2D.position,mpos,0.2)
	#$face.global_position = lerp($face.global_position,$PlayerBase/Marker2D.global_position,0.001)
	if(get_global_mouse_position().distance_to(global_position) <= 200):
		$range.color.a = lerp($range.color.a,0.0,0.3)
	else:
		$range.color.a = lerp($range.color.a,0.13,0.3)
	
	$Line2D.points[0] =  lerp($Line2D.points[0],$Line2D.points[1],0.4)


func _on_line_timeout() -> void:
	$Line2D.hide()
