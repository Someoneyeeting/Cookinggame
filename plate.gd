extends Node2D

var PLATE := preload("res://food.tscn")

func add_ingridiant():
	var plate :Sprite2D= PLATE.instantiate()
	plate.position.y = $ingridiatns.get_child_count() * -40
	plate.ind = $ingridiatns.get_child_count()
	$ingridiatns.add_child(plate)
