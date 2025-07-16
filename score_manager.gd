extends Node2D

var money : int = 0
var stars : int = 10
var served : int = 0

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_up")):
		$StarsUI.change_by(1)
	elif(event.is_action_pressed("ui_down")):
		$StarsUI.change_by(-1)


func change_hunger(amount : float):
	$hungerbar.hunger += amount
	$hungerbar.decrease = -amount
	
func set_hunger(amount : float):
	$hungerbar.hunger = amount

func add_star():
	$StarsUI.change_by(1)

func lose_star():
	$StarsUI.change_by(-1)

func increase_served():
	served += 1

func get_served():
	return served

func get_hunger_level():
	return int($hungerbar.hunger * 3 / $hungerbar.maxhunger)

func get_hunger():
	return $hungerbar.hunger

func get_max_hunger():
	return $hungerbar.maxhunger

func set_money(money : int):
	$MoneyUi.set_money(money)

func add_money(money : int):
	$MoneyUi.set_money($MoneyUi.money + money)
