extends Node2D
class_name Plate

var PLATE := preload("res://food.tscn")
var items : Array[ItemRes]

func add_ingridiant(item):
	if(is_empty() and (item.id != 0 and item.id != -1)):
		return
	var plate :Sprite2D= PLATE.instantiate()
	plate.position.y = $ingridiatns.get_child_count() * -40
	plate.ind = $ingridiatns.get_child_count()
	plate.item = item
	items.push_back(item)
	$ingridiatns.add_child(plate)


func _physics_process(delta: float) -> void:
	if(Globals.isaiming):
		position.y = lerp(position.y,40.,0.6)
	else:
		position.y = lerp(position.y,0.,0.6)

func canthrow():
	return not is_empty()

func is_empty():
	return items.size() == 0

func av_color():
	var clr := Color.WHITE
	clr.h = 0
	
	for i in items:
		clr.h += i.color.h / items.size()
	return clr
	

func clear():
	for i in $ingridiatns.get_children():
		i.queue_free()
	items.clear()
