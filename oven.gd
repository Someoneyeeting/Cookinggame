extends Node2D
class_name Oven


func get_thrown(ids):
	$close.play()
	await get_tree().create_timer(0.2).timeout
	$cooking.play()
