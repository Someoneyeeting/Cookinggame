extends Node2D
class_name StarUI

signal lose
var STAR := preload("res://star_sprite.tscn")
var normalcount := 6
var starcount := 5
var hypecount := 0
var totalstarcount := 0
var hypetarget : Node2D
var isclosed := false

func _physics_process(delta: float) -> void:
	totalstarcount = starcount + hypecount
	if(hypetarget):
		$mult.global_position.x = hypetarget.global_position.x - 20
	$mult.text = "x" + str(hypecount + 1)
	if(not isclosed):
		for i in range(normalcount):
			$letters.get_children()[i].global_position = $stars.get_children()[i].global_position - $letters.get_children()[i].size / 4
	
func _ready() -> void:
	for i in range(normalcount):
		var star = STAR.instantiate()
		star.position.x = i * 80
		if(i >= starcount):
			star.deactivate()
		else:
			star.activate()
		$stars.add_child(star)

func change_by(amount : int):
	if(amount < 0):
		lose_stars(-amount)
	else:
		add_stars(amount)

func set_star_count(amount : int):
	totalstarcount = starcount + hypecount
	while(totalstarcount > amount):
		lose_stars(1)
	while(totalstarcount < amount):
		add_stars(1)

func lose_stars(amount : int):
	if(isclosed):
		return
	if(hypecount > 0):
		lose_hype()
		totalstarcount = starcount + hypecount
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
	totalstarcount = starcount + hypecount
	

func add_stars(amount : int):
	if(isclosed):
		return
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

	totalstarcount = starcount + hypecount

func add_hype():
	var star = STAR.instantiate()
	star.position.x = (starcount + hypecount - 2) * 80
	var tween = get_tree().create_tween()
	tween.tween_property(star,"position:x",(starcount + hypecount - 1) * 80,0.1).set_trans(Tween.TRANS_CIRC) 
	tween.parallel().tween_property($hype,"position:x",(hypecount) * -80 / 1,0.1).set_trans(Tween.TRANS_CIRC) 
	tween.parallel().tween_property($stars,"position:x",(hypecount) * -80 / 1,0.1).set_trans(Tween.TRANS_CIRC) 
	star.hype()
	
	$mult.show()
	var tween1 = get_tree().create_tween()
	tween1.tween_property($mult,"position:y",50,0.2).set_trans(Tween.TRANS_CIRC)
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
	tween1.tween_propeFrty($mult,"position:y",$stars.position.x - 10,0.1).set_trans(Tween.TRANS_CIRC)
	#tween1.set_ease(Tween.EASE_IN)
	tween1.finished.connect($mult.hide)
	for i in $hype.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(i,"position:x",(normalcount - 1) * 80,0.1).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property($stars,"position:x",0,0.1).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property($hype,"position:x",0,0.1).set_trans(Tween.TRANS_CIRC)

		tween.finished.connect(i.queue_free)
		tween.finished.connect(func () : hypetarget = null)
	

func _death():
	isclosed = true
	Globals.closed.emit()
	for i in range(normalcount):
		$stars.get_children()[i].die()
		$letters.show()
		
	#Globals.lose()

func reset():
	isclosed = false
	for i in $stars.get_children():
		i.reset()
	$letters.hide()

func mult_stars(node : Node2D):
	for i in range(hypecount):
		node.mult()
		if(i < $hype.get_child_count()):
			$hype.get_children()[i].expand()
			await get_tree().create_timer(0.01).timeout
	node.finish()
