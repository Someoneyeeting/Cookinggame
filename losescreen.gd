extends Node2D


func lose():
	show()
	$music.play()

func _on_button_pressed() -> void:
	get_tree().paused = false
	hide()
	$music.stop()
	Globals.restart()
