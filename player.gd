extends CharacterBody2D


var v : float = 0
var isjumping := false
@export var max_fall_speed : float = 600
@export var g : float = 23.
@export var move_speed : float = 200
@export var jump_height : float = 600

func jump():
	%cyote.stop()
	%jumpbuffer.stop()
	velocity.y = -jump_height
	isjumping = true
	
func _handle_fall():
	if(is_on_floor()):
		velocity.y = 0
	if(velocity.y < max_fall_speed):
		velocity.y += g
	if(velocity.y > 0):
		velocity.y += g * 0.7
		isjumping = false
	if(isjumping and Input.is_action_just_released("jump")):
		velocity.y /= 2

func _handle_jump():
	_handle_fall()
	if(is_on_floor()):
		$%cyote.start()
	if(Input.is_action_just_pressed("jump")):
		%jumpbuffer.start()
	if(%cyote.time_left > 0 and %jumpbuffer.time_left > 0):
		jump()
		
func _handle_move():
	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	var sprinting = Input.is_action_pressed("sprint")
	v = lerp(v,dir * move_speed * (2.4 if sprinting else 1),0.5)


func _physics_process(delta: float) -> void:
	_handle_jump()
	_handle_move()
	
	velocity.x = v
	move_and_slide()
