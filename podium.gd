extends Node2D
class_name Podium

@export var item : ItemRes
var disabled := false

func _ready() -> void:
	$Sprite2D.texture = item.texture

func disable():
	disabled = true
	modulate = Color.BLACK
	$click/CollisionShape2D.disabled = true

func enable():
	disabled = false
	modulate = Color.WHITE
	$click/CollisionShape2D.disabled = false

func pick_up():
	if($AnimationPlayer.current_animation == "spin"):
		$AnimationPlayer.play("spin_reverse")
	else:
		$AnimationPlayer.play("spin")
