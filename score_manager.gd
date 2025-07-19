extends Node2D

var money : int = 0
var stars : int = 10
var served : int = 0

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_up")):
		%StarsUI.change_by(1)
	elif(event.is_action_pressed("ui_down")):
		%StarsUI.change_by(-1)

func show_hunger():
	var tween = get_tree().create_tween()
	tween.tween_property($hungerbar,"position:y",671.0,2.).set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($hungerbar/Label,"modulate:a",0,10)

func change_hunger(amount : float):
	%hungerbar.hunger += amount
	if(amount < 0):
		%hungerbar.decrease = -amount
	else:
		%hungerbar.decrease = 0

func set_hunger(amount : float):
	%hungerbar.hunger = amount

func set_stars(amount : int):
	%StarsUI.change_by(%StarsUI.starcount - %StarsUI.totalstarcount - %StarsUI.hypecount)

func add_star():
	%StarsUI.change_by(1)

func lose_star():
	%StarsUI.change_by(-1)

func increase_served():
	served += 1

func get_served():
	return served

func get_hunger_level():
	return int(%hungerbar.hunger * 3 / %hungerbar.maxhunger)

func get_hunger():
	return %hungerbar.hunger

func get_max_hunger():
	return %hungerbar.maxhunger

func set_money(money : int):
	%MoneyUi.set_money(money)

func add_money(money : int):
	%MoneyUi.add_money(money)

func mult_stars(node : Node2D):
	%StarsUI.mult_stars(node)

func add_actual_money(amount : int):
	print(amount)
	if(amount > 0):
		%MoneyUi.add_actual_money(amount * (%StarsUI.hypecount + 1))
	else:
		%MoneyUi.add_actual_money(amount)

func clear_money():
	$MoneyUi.clear()
