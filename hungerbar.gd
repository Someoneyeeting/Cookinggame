extends Node2D


var hunger :float= 99
var hungerlerp : float = 0.
var maxhunger :int = 100
var decrease :float = 0
var decreaselerp : float = 0
var ogsize := 0

func _ready() -> void:
	ogsize = $bar.size.x

func _physics_process(delta: float) -> void:
	#$bar.size.x = lerp($bar.size.x,lerp(0,ogsize,hunger / 160),0.4)
	decreaselerp = lerp(decreaselerp,decrease,0.1)
	decrease = lerp(decrease,delta,0.08)
	hunger -= delta
	hunger = clamp(hunger,0,maxhunger)
	hungerlerp = lerp(hungerlerp,hunger,0.3)
	
	$bar.material.set_shader_parameter("val",hungerlerp/maxhunger)
	$bar.material.set_shader_parameter("decrease",(decreaselerp * 30.)/maxhunger)
