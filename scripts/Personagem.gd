extends KinematicBody2D

# Constants
const GRAVITY = 300
const UP = Vector2(0, -1)
const SPEED = 100
const JUMP = 180

# Variables
var motion = Vector2()
var dir = 1 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# Gravidade
	if !is_on_floor():
		motion.y += GRAVITY * delta
	
	# Mover
	if Input.is_action_pressed("ui_right"):
		dir = 1
		$Sprite.flip_h = false
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("andando")
	elif Input.is_action_pressed("ui_left"):
		dir = -1
		$Sprite.flip_h = true
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("andando")
	else:
		dir = 0
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("parado")
	
	# Pular
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			motion.y = -JUMP
			$AnimationPlayer.play("pulando")
			$pulo.play()
			
	# Drop
	if !is_on_floor():
		if motion.y > 0:
			if $AnimationPlayer.current_animation == "pulando":
				# $AnimationPlayer.play("caindo")
				pass
			
	# Physic
	move_and_slide(motion, UP)
	pass
