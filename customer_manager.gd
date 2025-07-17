extends Node2D

var CUSTOMER := preload("res://customer.tscn")

@export var recipesUnlock : RecipeUnlock

var waiting :Array[Customer]= []
var cserving :Array[Customer]= []
var is_intro := true

var line :Array[bool]= [false,false,false,false,false]

var customerind = 0

var recipes : Array[RecipeRes] = []

func _ready():
	$CanvasLayer/ColorRect.show()

func _on_newcustomer_timeout() -> void:
	new_customer()

func get_ind_pos(ind : int):
	var pos = $Marker2D.global_position
	pos.x += ind * 220
	if(ind % 2 == 1):
		pos.y -= 30
	return pos

func new_customer():
	if(Globals.get_served() in recipesUnlock.recipes):
		recipes.append(recipesUnlock.recipes[Globals.get_served()])
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
	
	customerind += 1
	customerind %= 3
	customer.enter_line()
	waiting.append(customer)
	customer.set_recipe(recipes[randi_range(0,recipes.size() - 1)])
	customer.z_index = -waiting.size()
	$customers.add_child(customer)

func customer_out(ind : int):
	line[ind] = false

func _physics_process(delta: float) -> void:
	$CanvasLayer/ColorRect.material.set_shader_parameter("pos",Globals.player.global_position / Vector2(1280,720))
	
	if(is_intro):
		Globals.set_hunger(50)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$customers/Customer.global_position = get_ind_pos(2)
	$customers/Customer.global_position.y -= 300
	$customers/Customer.walkin(get_ind_pos(2))


func _on_customer_shot() -> void:
	$CanvasLayer/controls.hide()
	
