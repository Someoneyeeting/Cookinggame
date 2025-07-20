extends Node2D


func lose():
	if (Globals.get_money() < 0):
		$Label3.text = "You are $" + str(-Globals.get_money()) + " in debt to the restaurant"
	else:
		$Label3.text = "You made $" + str(Globals.get_money()) + " for the resturant"
	show()
	$music.play()

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("leftc")):
		if($Button.get_global_rect().has_point(get_global_mouse_position())):
			restart()

func restart():
	get_tree().paused = false
	hide()
	$music.stop()
	Globals.restart()
