extends Node2D


var hunger :float= 100
var ogsize := 0

func _ready() -> void:
	ogsize = $bar.size.x

func _physics_process(delta: float) -> void:
	$bar.size.x = lerp($bar.size.x,lerp(0,ogsize,hunger / 100),0.4)
	hunger -= delta * 5
	hunger = clamp(hunger,0,100)
