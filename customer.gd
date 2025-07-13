extends Node2D
class_name Customer

var serving := false

@export var recipe : RecipeRes
func enter():
	serving = true
	z_index = 1
	$RecipeDisplay.recp = recipe

func out(size : float):
	$AudioStreamPlayer2D.play()
	$outanimation.start()
	var tween = get_tree().create_tween()
	var dir = Globals.player.global_position - global_position
	global_rotation = sign(dir.x) * 0.1
	dir = dir.normalized()
	global_position -= dir * 40 * (size / 4)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"global_position",global_position - dir * 100 * (size / 30),0.6).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(queue_free)

func enter_line():
	$AnimationPlayer.play("enter_line")

func _physics_process(delta: float) -> void:
	#$ColorRect.color = lerp($ColorRect.color,Color.WHITE if serving else Color.DARK_GRAY,0.01)
	
	var playerhas = Globals.player.plate.get_as_ids()
	if(recipe.is_matching(playerhas)):
		$ColorRect.color = Color.GOLD
	elif(recipe.matching_so_far(playerhas)):
		$ColorRect.color = Color.GREEN
	else:
		$ColorRect.color = Color.RED
	
	var count = Globals.player.plate.get_count()
	if(count < 35):
		$ColorRect.position.x = -61.0
		$GPUParticles2D.emitting = false
	else:
		$ColorRect.position.x = -61.0 + (randf_range(count,-count) - 35) / 32
		$GPUParticles2D.emitting = true


func _on_outanimation_timeout() -> void:
	visible = not visible
