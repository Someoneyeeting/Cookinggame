extends Node2D

var PLATE := preload("res://food.tscn")

func add_ingridiant():
	var plate :Sprite2D= PLATE.instantiate()
	plate.position.y = $ingridiatns.get_child_count() * -40
	plate.ind = $ingridiatns.get_child_count()
	$ingridiatns.add_child(plate)


func _physics_process(delta: float) -> void:
	if(Globals.isaiming):
		position.y = lerp(position.y,40.,0.6)
	else:
		position.y = lerp(position.y,0.,0.6)

func canthrow():
	return $ingridiatns.get_child_count() > 0

func clear():
	for i in $ingridiatns.get_children():
		i.queue_free()
