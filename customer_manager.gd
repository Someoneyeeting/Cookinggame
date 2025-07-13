extends Node2D

var CUSTOMER := preload("res://customer.tscn")

var waiting :Array[Customer]= []
var cserving :Array[Customer]= []

var customerind = 0


func serve_customer():
	if(cserving.is_empty()):
		return
	var cus :Customer= cserving.pop_front()
	cus.out()
	

func _on_newcustomer_timeout() -> void:
	var customer :Customer= CUSTOMER.instantiate()
	customer.global_position = $Marker2D.global_position
	customer.global_position.x += (customerind - 1) * 250 + randf_range(-50,50)
	customer.global_position.y -= waiting.size() * 10
	customerind += 1
	customerind %= 3
	customer.enter_line()
	waiting.append(customer)
	customer.z_index = -waiting.size()
	$customers.add_child(customer)
	if(waiting.size() > 8):
		$newcustomer.stop()

func _physics_process(delta: float) -> void:
	while(cserving.size() < 3 and not waiting.is_empty()):
		var nextcus :Customer = waiting.pop_front()
		cserving.push_back(nextcus)
		nextcus.global_position.y = $Marker2D.global_position.y
		nextcus.enter()
