extends Node2D
class_name Customer

signal served(recipe : Array[RecipeRes])
signal out(ind : int)

var ind : int
var serving := false
var plate := preload("res://foods/plate.tres")
var chicken := preload("res://foods/chicken.tres")
@onready var waittime :float= $waittime.wait_time

@export var recipe : RecipeRes
var walkdir := Vector2.ZERO
var t : float = 0.
@onready var headpos : float = $body/CusHead.position.y

func set_recipe(recp : RecipeRes):
	recipe = recp.duplicate()

func _ready() -> void:
	recipe = recipe.duplicate()
	Globals.eat.connect(check_eat)
	serving = true
	z_index = 1
	served.connect(Globals._served)
	$RecipeDisplay.set_recp(recipe)
	

func check_eat(ids):
	if(walkdir != Vector2.ZERO):
		return 
	if(recipe.is_matching(ids)):
		#print("yes")
		Globals.change_hunger(60)
		Globals.add_money(-5)
		$outanimation.start()
		$body.modulate = Color.BLUE
		get_tree().create_timer(0.4).timeout.connect(_out)
		Globals.lose_star()
	else:
		if($waittime.time_left <= 6):
			time_out()
		else:
			$waittime.start(max(0,$waittime.time_left - 6))
		

func get_thrown(items : Array[ItemRes]):
	var size : int = items.size()
	if(walkdir != Vector2.ZERO):
		size = 16
	$outanimation.start()
	var tween = get_tree().create_tween()
	var dir = Globals.player.global_position - global_position
	global_rotation = sign(dir.x) * 0.1
	dir = dir.normalized()
	
	
	if(walkdir == Vector2.ZERO):
		var ids = []
		for i in items:
			ids.push_back(i.id)
		if(recipe.is_matching(ids)):
			Globals.add_star()
			served.emit(recipe)
			Globals.add_money(10)
			ScoresManager.shoot($body/CusHead.global_position,dir * -20,10)
			
		elif(not recipe.matching_so_far(ids) and ids.size() >= recipe.items.size() / 2):
			Globals.lose_star()
		else:
			Globals.lose_star()
			Globals.add_money(-10)
			ScoresManager.shoot($body/CusHead.global_position,dir * -20,-10)
		
	global_position -= dir * 70 * (sqrt(size))
	$waittime.paused = true
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"global_position",global_position - dir * 100 * (size / 30),0.6).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(_out)

func walkin(pos : Vector2):
	$AnimationPlayer.play("walk")
	var tween := create_tween()
	tween.tween_property(self,"global_position",pos,0.5)
	tween.finished.connect(start)

func start():
	$AnimationPlayer.stop()

func time_out():
	Globals.lose_star()
	$AnimationPlayer.play("walk")
	walkdir = Vector2(randf_range(-30,30),-30)

func enter_line():
	pass
	#$AnimationPlayer.play("enter_line")

func _physics_process(delta: float) -> void:
	#$body.modulate = lerp($body.modulate,Color.WHITE if serving else Color.DARK_GRAY,0.01)
	t += delta
	if(walkdir != Vector2.ZERO):
		position += walkdir * 0.3 * Engine.time_scale
		#$walk.volume_db -= 0.4 * Engine.time_scale
		#$walk.volume_db = randf_range(2.,3.)
	
	var playerhas = Globals.player.plate.get_as_ids()
	if($outanimation.time_left == 0):
		pass
		if(recipe.is_matching(playerhas)):
			#$RecipeDisplay.hide()
			$body/CusHead.position.y = headpos - 13 + randf_range(-1,1)
			$body/CusHead.frame = 1
			$body/CusHead.rotation += delta
			%glow.material.set_shader_parameter("strength",randf_range(0.5,0.8))
		elif(recipe.matching_so_far(playerhas)):
			#$RecipeDisplay.show()
			$body/CusHead.position.y = headpos +  sin(t * 6) * 4
			$body/CusHead.frame = 0
			$body/CusHead.rotation = 0
			%glow.material.set_shader_parameter("strength",0.)
		else:
			#$RecipeDisplay.show()
			$body/CusHead.position.y = headpos
			$body/CusHead.frame = 0
			$body/CusHead.rotation = 0
			%glow.material.set_shader_parameter("strength",0.)
	
	var count = Globals.player.plate.get_count()
	if(count < 35):
		$body.position.x = 0
		$GPUParticles2D.emitting = false
	else:
		$body.position.x =  (randf_range(count,-count) - 35) / 32
		$GPUParticles2D.emitting = true
	
	$customertimer.set_timer($waittime.time_left / waittime)


func _on_outanimation_timeout() -> void:
	visible = not visible


func _on_waittime_timeout() -> void:
	time_out()


func _out():
	out.emit(ind)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_out()
