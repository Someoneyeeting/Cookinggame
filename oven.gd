extends Node2D
class_name Oven


func get_thrown(ids):
	$Oven.play("cooking")
	$close.play()
	await get_tree().create_timer(0.2).timeout
	$cooking.play()
	$cooktime.start()


func _on_cooktime_timeout() -> void:
	$Oven.play("closed")
