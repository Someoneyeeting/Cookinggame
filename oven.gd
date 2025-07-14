extends Node2D
class_name Oven

var rot :float= 0.0

func get_thrown(ids):
	$Oven.play("cooking")
	$close.play()
	await get_tree().create_timer(0.2).timeout
	$cooking.play()
	$Targetable/CollisionShape2D.disabled = true
	$cooktime.start()

func _physics_process(delta: float) -> void:
	$cooking.pitch_scale = Engine.time_scale
	if(Engine.time_scale < 1):
		$cooking.volume_db = 16
	else:
		$cooking.volume_db = 24

func _on_cooktime_timeout() -> void:
	$Targetable/CollisionShape2D.disabled = false
	$Oven.play("closed")
