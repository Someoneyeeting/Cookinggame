extends Node2D
class_name Customer

var serving := false

func enter():
	serving = true
	z_index = 1

func out():
	$AudioStreamPlayer2D.play()
	var tween = get_tree().create_tween()
	
	var dir = Globals.player.global_position - global_position
	global_rotation = sign(dir.x) * 0.1
	dir = dir.normalized()
	global_position -= dir * 40
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"global_position",global_position - dir * 100,0.6).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)

func enter_line():
	$AnimationPlayer.play("enter_line")

func _physics_process(delta: float) -> void:
	$ColorRect.color = lerp($ColorRect.color,Color.WHITE if serving else Color.DARK_GRAY,0.01)


func _on_outanimation_timeout() -> void:
	$ColorRect.visible = not $ColorRect.visible
