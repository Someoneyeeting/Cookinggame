extends Node2D

var money : int = 0
var stars : int = 10


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_up")):
		$StarsUI.change_by(1)
	elif(event.is_action_pressed("ui_down")):
		$StarsUI.change_by(-1)


func change_hunger(amount : float):
	$hungerbar.hunger += amount
	
func set_hunger(amount : float):
	$hungerbar.hunger = amount
