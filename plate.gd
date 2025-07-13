extends Node2D
class_name Plate

var PLATE := preload("res://food.tscn")
var items : Array[ItemRes]

func add_ingridiant(item):
	if(is_empty() and (item.id != 0 and item.id != -1)):
		return
	if(not is_empty() and items[0].id == -1):
		return
	var plate :Sprite2D= PLATE.instantiate()
	var targpos := $ingridiatns.get_child_count() * -4.32 / scale.x
	plate.position.y = targpos - 100
	var tween = get_tree().create_tween()
	
	tween.tween_property(plate,"position",Vector2(0,targpos),0.25)
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
	
func get_count():
	return items.size()

func get_as_ids():
	var ids = []
	
	for i in items:
		ids.append(i.id)
	
	return ids
	

func clear():
	for i in $ingridiatns.get_children():
		i.queue_free()
	items.clear()
