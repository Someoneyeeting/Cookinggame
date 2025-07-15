extends Node2D
class_name Plate

var PLATE := preload("res://food.tscn")
var items : Array[ItemRes]
var has_chicken := false
var itemcount := 0

func can_add_item(item : ItemRes):
	if(is_poison()):
		return false
	if(not is_empty() and item.id == -1):
		return false
		
	return true

func add_ingridiant(item : ItemRes):
	if(item.id == 2):
		has_chicken = true
	var plate :Sprite2D= PLATE.instantiate()
	var targpos := itemcount * -7 / scale.x
	plate.position.y = targpos - 350
	var tween = get_tree().create_tween()
	tween.tween_property(plate,"position",Vector2(0,targpos),0.3)
	tween.finished.connect($land.play)
	$pick.pitch_scale = randf_range(0.1,0.3)
	if(item.id == 2):
		$chicken.play()
	else:
		$pick.play()
	#tween.set_ease(Tween.EASE_OUT)
	plate.ind = itemcount
	plate.item = item
	items.push_back(item)
	$ingridiatns.add_child(plate)
	itemcount += 1


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
	return clr
	
func get_count():
	return items.size()

func get_as_ids():
	var ids = []
	
	for i in items:
		ids.append(i.id)
	
	return ids


func set_items(newitems : Array[ItemRes]):
	clear()
	for i in newitems:
		add_ingridiant(i)

func clear():
	for i in $ingridiatns.get_children():
		i.queue_free()
	items.clear()
	itemcount = 0
	has_chicken = false

func is_poison():
	return not is_empty() and items[0].id == -1
