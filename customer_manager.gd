extends Node2D

var CUSTOMER := preload("res://customer.tscn")

var waiting :Array[Customer]= []
var cserving :Array[Customer]= []

var customerind = 0



func _on_newcustomer_timeout() -> void:
	if($customers.get_child_count() == 3):
		return
	var customer :Customer= CUSTOMER.instantiate()
	customer.global_position = $Marker2D.global_position
	customer.global_position.x += (customerind - 1) * 250 + randf_range(-50,50)
	#customer.global_position.y -= $customers.get_child_count() * 10
	customerind += 1
	customerind %= 3
	customer.enter_line()
	waiting.append(customer)
	customer.z_index = -waiting.size()
	$customers.add_child(customer)

func _physics_process(delta: float) -> void:
	while(cserving.size() < 3 and not waiting.is_empty()):
		var nextcus :Customer = waiting.pop_front()
		cserving.push_back(nextcus)
		nextcus.global_position.y = $Marker2D.global_position.y
		nextcus.enter()
