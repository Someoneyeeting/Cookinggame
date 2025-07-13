extends Node2D
class_name Podium

@export var item : ItemRes

func _ready() -> void:
	$Sprite2D.texture = item.texture
