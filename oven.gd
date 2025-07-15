extends Node2D
class_name Oven

var rot :float= 0.0
var content : Array[ItemRes]
func get_thrown(items : Array[ItemRes]):
	start_cooking()


func start_cooking():
	$close.play()
	$Oven.play("cooking")
	$close.play()
	$Targetable/CollisionShape2D.disabled = true
	$pickup/CollisionShape2D.disabled = true
	await get_tree().create_timer(0.2).timeout
	$cooking.play()
	$cooktime.start()

func open():
	if($Oven.animation != "open"):
		$open.play()
		$Oven.play("open")

func set_content(items : Array[ItemRes]):
	content = items.duplicate()
	for i in range(content.size()):
		if(content[i].cooked):
			content[i] = content[i].cooked
func _physics_process(delta: float) -> void:
	$cooking.pitch_scale = Engine.time_scale
	if(Engine.time_scale < 1):
		$cooking.volume_db = 16
	else:
		$cooking.volume_db = 24

func pop_content():
	var items = content.duplicate()
	content.clear()
	return items

func replace_content(newcontent : Array[ItemRes]):
	var items = content.duplicate()
	set_content(newcontent)
	return items

func _on_cooktime_timeout() -> void:
	$Targetable/CollisionShape2D.disabled = false
	$pickup/CollisionShape2D.disabled = false
	$Oven.play("closed")
