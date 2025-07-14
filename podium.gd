extends Node2D
class_name Podium

@export var item : ItemRes

func _ready() -> void:
	$Sprite2D.texture = item.texture

func pick_up():
	if($AnimationPlayer.current_animation == "spin"):
		$AnimationPlayer.play("spin_reverse")
	else:
		$AnimationPlayer.play("spin")
