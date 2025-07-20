extends Node2D


var hunger :float= 150
var hungerlerp : float = 0.
var maxhunger :int = 140
var decrease :float = 0
var decreaselerp : float = 0
var ogsize := 0

func _ready() -> void:
	ogsize = $bar.size.x
	$ColorRect.position.x = $background.size.x * 0.325
	$ColorRect2.position.x = $background.size.x * 0.666666

func _physics_process(delta: float) -> void:
	if(hunger <= -8):
		Globals.lose()
	if(Globals.isintro):
		hunger = max(2,hunger)
	#$bar.size.x = lerp($bar.size.x,lerp(0,ogsize,hunger / 160),0.4)
	decreaselerp = lerp(decreaselerp,sqrt(decrease / 2.),0.5)
	decrease = max(decrease,0.)
	decrease = lerp(decrease,delta * 0.5,0.1)
	hunger = min(hunger,maxhunger)
	hunger -= delta * 0.5
	hungerlerp = lerp(hungerlerp,hunger,0.3)
	
	$bar.material.set_shader_parameter("val",hungerlerp/maxhunger)
	$bar.material.set_shader_parameter("decrease",(decreaselerp * 10.)/maxhunger)
