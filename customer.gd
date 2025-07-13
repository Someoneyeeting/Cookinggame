extends Node2D
class_name Customer

var serving := false

func enter():
	serving = true
	z_index = 1

func out():
	$outanimation.start()

func enter_line():
	$AnimationPlayer.play("enter_line")

func _physics_process(delta: float) -> void:
	$ColorRect.color = lerp($ColorRect.color,Color.WHITE if serving else Color.DARK_GRAY,0.01)


func _on_outanimation_timeout() -> void:
	$ColorRect.visible = not $ColorRect.visible
