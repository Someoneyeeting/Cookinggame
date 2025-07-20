extends Node2D
class_name Podium

@export var item : ItemRes
var disabled := false
var v : float = 0

func _ready() -> void:
	Globals.walkaway.connect(walkaway)
	$Sprite2D.texture = item.texture

func _physics_process(delta: float) -> void:
	if(v != 0):
		position.y += v

func walkaway():
	v = -8
	$walk.play()
	#$walk.play()
	
	

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
