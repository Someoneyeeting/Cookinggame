extends Node2D
class_name StarUI

signal lose
var STAR := preload("res://star_sprite.tscn")
var normalcount := 6
var starcount := 5
var hypecount := 0
var totalstarcount := 0
var hypetarget : Node2D

func _physics_process(delta: float) -> void:
	totalstarcount = starcount + hypecount
	if(hypetarget):
		$mult.global_position.y = hypetarget.global_position.y - 20
	$mult.text = "x" + str(hypecount + 1)
	
func _ready() -> void:
	for i in range(normalcount):
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
	if(starcount <= 1):
		for i in $stars.get_children():
			i.panic()

func add_stars(amount : int):
	$death.hide()
	for i in amount:
		var ind = starcount
		starcount += 1
		if(ind >= normalcount):
			add_hype()
			continue
		$stars.get_children()[ind].activate()
	if(hypecount == 0):
		$gainstar.play()
	starcount = min(starcount,normalcount)
	if(starcount > 1):
		for i in $stars.get_children():
			i.unpanic()


func add_hype():
	var star = STAR.instantiate()
	star.position.y = (starcount + hypecount - 2) * -80
	var tween = get_tree().create_tween()
	tween.tween_property(star,"position:y",(starcount + hypecount - 1) * -80,0.1).set_trans(Tween.TRANS_CIRC) 
	tween.parallel().tween_property($hype,"position:y",(hypecount) * 80 / 1,0.1).set_trans(Tween.TRANS_CIRC) 
	tween.parallel().tween_property($stars,"position:y",(hypecount) * 80 / 1,0.1).set_trans(Tween.TRANS_CIRC) 
	star.hype()
	
	$mult.show()
	var tween1 = get_tree().create_tween()
	tween1.tween_property($mult,"position:x",50,0.2).set_trans(Tween.TRANS_CIRC)
	tween1.parallel().tween_property($mult,"rotation_degrees",randf_range(-30,30),0.1).set_trans(Tween.TRANS_BOUNCE)
	
	$hype.add_child(star)
	$gainhype.play()
	hypecount += 1
	$gainhype.pitch_scale = 1 + (hypecount * 0.1)
	hypetarget = star


func lose_hype():
	hypecount = 0
	$losehype.play()
	$crowd.play()
	var tween1 = get_tree().create_tween()
	tween1.tween_property($mult,"position:x",$stars.position.x - 10,0.1).set_trans(Tween.TRANS_CIRC)
	#tween1.set_ease(Tween.EASE_IN)
	tween1.finished.connect($mult.hide)
	for i in $hype.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(i,"position:y",(normalcount - 1) * -80,0.1).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property($stars,"position:y",0,0.1).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property($hype,"position:y",0,0.1).set_trans(Tween.TRANS_CIRC)

		tween.finished.connect(i.queue_free)
		tween.finished.connect(func () : hypetarget = null)
	

func _death():
	Globals.lose()

func mult_stars(node : Node2D):
	for i in range(hypecount):
		node.mult()
		if(i < $hype.get_child_count()):
			$hype.get_children()[i].expand()
			await get_tree().create_timer(0.01).timeout
	node.finish()
