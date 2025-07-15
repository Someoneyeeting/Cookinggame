extends Node2D
class_name StarUI

signal lose
var STAR := preload("res://star_sprite.tscn")
var starcount := 3
var hypecount := 0
var totalstarcount := 0
var hypetarget : Node2D

func _physics_process(delta: float) -> void:
	totalstarcount = starcount + hypecount
	if(hypetarget):
		$mult.global_position.y = hypetarget.global_position.y - 20
	$mult.text = "x" + str(hypecount + 1)
func _ready() -> void:
	for i in range(5):
		var star = STAR.instantiate()
		star.position.y = i * -80
		if(i >= starcount):
			star.deactivate()
		else:
			star.activate()
		$stars.add_child(star)

func change_by(amount : int):
	if(amount > 0):
		add_stars(amount)
	if(amount < 0):
		lose_stars(-amount)

func lose_stars(amount : int):
	if(hypecount > 0):
		lose_hype()
		return
	$losestar.play()
	for i in amount:
		starcount -= 1
		var ind = starcount
		if(ind < 0):
			_death()
			break
		$stars.get_children()[ind].deactivate()
	starcount = max(starcount,0)

func add_stars(amount : int):
	$death.hide()
	for i in amount:
		var ind = starcount
		starcount += 1
		if(ind >= 5):
			add_hype()
			continue
		$stars.get_children()[ind].activate()
	
	if(hypecount == 0):
		$gainstar.play()
	starcount = min(starcount,5)

func add_hype():
	var star = STAR.instantiate()
	star.position.y = (starcount + hypecount - 2) * -80
	var tween = get_tree().create_tween()
	tween.tween_property(star,"position:y",(starcount + hypecount - 1) * -80,0.1).set_trans(Tween.TRANS_CIRC) 
	tween.parallel().tween_property($hype,"position:y",(hypecount) * 80 / 2,0.1).set_trans(Tween.TRANS_CIRC) 
	tween.parallel().tween_property($stars,"position:y",(hypecount) * 80 / 2,0.1).set_trans(Tween.TRANS_CIRC) 
	star.hype()
	$hype.add_child(star)
	$gainhype.play()
	hypecount += 1
	$gainhype.pitch_scale = 1 + (hypecount * 0.1)
	hypetarget = star


func lose_hype():
	hypecount = 0
	$losehype.play()
	$crowd.play()
	for i in $hype.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(i,"position:y",4 * -80,0.1).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property($stars,"position:y",0,0.1).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property($hype,"position:y",0,0.1).set_trans(Tween.TRANS_CIRC)

		tween.finished.connect(i.queue_free)
		tween.finished.connect(func () : hypetarget = null)
	

func _death():
	$death.show()
	lose.emit()
