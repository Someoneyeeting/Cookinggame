extends Node2D

var CUSTOMER := preload("res://customer.tscn")

@export var recipesUnlock : RecipeUnlock

var waiting :Array[Customer]= []
var cserving :Array[Customer]= []
var lock_hunger := true
var intro := 0

var line :Array[bool]= [false,false,false,false,false]


var lastrecp := -1
var recipes : Array[RecipeRes] = []

func reset():
	recipes.clear()

func _ready():
	Globals.closed.connect(closed)
	$CanvasLayer/ColorRect.show()
	if(not Globals.isintro):
		$AnimationPlayer.stop()
		$newcustomer.start()
		$CanvasLayer.hide()
		lock_hunger = false
		Globals.show_hunger()
		for i in $customers.get_children():
			i.queue_free()

func closed():
	$newcustomer.paused = true

func _on_newcustomer_timeout() -> void:
	new_customer()

func get_ind_pos(ind : int):
	var pos = $Marker2D.global_position
	pos.x += ind * 220
	if(ind % 2 == 1):
		pos.y -= 30
	return pos

func new_customer():
	if(Globals.get_served() in recipesUnlock.recipes and lastrecp != Globals.get_served()):
		recipes.append(recipesUnlock.recipes[Globals.get_served()])
		lastrecp = Globals.get_served()
	var ind : int = -1
	var inds = [0,1,2,3,4]
	inds.shuffle()
	for i in inds:
		if(not line[i]):
			line[i] = true
			ind = i
			break
			
	if(ind == -1):
		return
	
	var customer :Customer= CUSTOMER.instantiate()
	var pos : Vector2 = get_ind_pos(ind)
	
	customer.walkin(pos)
	customer.global_position = pos + Vector2(0,-500)
	#customer.global_position.y -= $customers.get_child_count() * 10
	
	customer.ind = ind
	customer.out.connect(customer_out)
	
	waiting.append(customer)
	customer.set_recipe(recipes[randi_range(0,recipes.size() - 1)])
	customer.z_index = -waiting.size()
	$customers.add_child(customer)

func customer_out(ind : int):
	line[ind] = false
	if($newcustomer.paused and not Globals.isintro and $customers.get_child_count() <= 1):
		print("yeah")
		await get_tree().create_timer(2).timeout
		Globals.walkaway.emit()
		await get_tree().create_timer(4).timeout
		Globals.lose()

func three_intro_customer():
	
	$customers/Customer2.global_position = get_ind_pos(0)
	$customers/Customer2.global_position.y -= 300
	$customers/Customer2.walkin(get_ind_pos(0))
	await get_tree().create_timer(0.4).timeout
	
	$customers/Customer3.global_position = get_ind_pos(2)
	$customers/Customer3.global_position.y -= 300
	$customers/Customer3.walkin(get_ind_pos(2))
	await get_tree().create_timer(0.4).timeout
	
	$customers/Customer4.global_position = get_ind_pos(4)
	$customers/Customer4.global_position.y -= 300
	$customers/Customer4.walkin(get_ind_pos(4))
	await get_tree().create_timer(0.4).timeout
	lock_hunger = false

func _physics_process(delta: float) -> void:
	$CanvasLayer/ColorRect.material.set_shader_parameter("pos",Globals.player.global_position / Vector2(1280,720))
	
	if(lock_hunger):
		Globals.set_hunger(65)

func _play_music():
	$music.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$customers/Customer.global_position = get_ind_pos(2)
	$customers/Customer.global_position.y -= 300
	$customers/Customer.walkin(get_ind_pos(2))


func _on_customer_shot(ind : int = 0) -> void:
	intro += 1
	if(intro == 1):
		$CanvasLayer/controls.hide()
		await get_tree().create_timer(1.3).timeout
		Globals.unhide_stuff.emit()
		await get_tree().create_timer(0.6).timeout
		Globals.show_hunger()
		await get_tree().create_timer(1.5).timeout
		three_intro_customer()
	elif(intro == 1):
		Globals.player.show_glow()
	elif(intro == 4):
		Globals.player.hide_glow()
		Globals.set_hunger(80)
		Globals.isintro = false
		var tween = get_tree().create_tween()
		tween.tween_property($music,"volume_db",-70,2.)
		await tween.finished
		await get_tree().create_timer(1).timeout
		$newcustomer.start()
		Globals.start_music()
	
