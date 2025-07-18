extends Node2D


func _on_button_pressed() -> void:
	get_tree().paused = false
	Globals.restart()
