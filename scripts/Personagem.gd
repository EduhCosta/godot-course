extends KinematicBody2D

# Signals
signal levarDano
signal aumentarScore

# Constants
const GRAVITY = 300
const UP = Vector2(0, -1)
const SPEED = 100
const JUMP = 180
const CAMERAMAX = 0
const CAMERAMIN = -50

# Variables
var motion = Vector2()
var dir = 1 
var cameraOffset = -50
var hp = 100
var colisorDano = false
var objetoInimigo

# Called when the node enters the scene tree for the first time.
func _ready():
	# Conect damage area
	$areaDano.connect("area_entered", self, "_on_areaDano_area_entered")
	
	# Connect to hit area
	$areaBater.connect("area_entered", self, "_on_areaBater_area_entered")
	
	# Connect when exited to hit area
	$areaBater.connect("area_exited", self, "_on_areaBater_area_exited")
	
	# Connect dead time
	$tempoMorrer.connect("timeout", self, "tempoMorrer")
		
	# Start animation
	$AnimationPlayer.play("parado")
	pass 

# Define behavior
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
				$AnimationPlayer.play("caindo")
				
			
	# Physic
	move_and_slide(motion, UP)
	
	# Move camera
	$Camera2D.offset.y = cameraOffset
	if Input.is_action_pressed("ui_down"):
		cameraOffset += 1
	if !Input.is_action_pressed("ui_down"):
		cameraOffset -= 1
		
	# Max camera
	if cameraOffset > 0 :
		cameraOffset = CAMERAMAX
		
	# MIN camera
	if cameraOffset < -50 :
		cameraOffset = CAMERAMIN
		
	# Dead
	if hp <= 0:
		dead()	

	pass

# Dead method
func dead():
	$Particles2D.emitting = true
	$Sprite.visible = false
	$tempoMorrer.start()
	set_physics_process(false)
	pass

# Restart scene
func tempoMorrer():
	get_tree().reload_current_scene()
	pass

# Colission with enemy
func _on_areaDano_area_entered(area):
	if area.is_in_group("cristal_a"):
		emit_signal("aumentarScore", 150)
		
	if area.is_in_group("inimigo"):
		if $tempo_invencivel.time_left == 0:
			if colisorDano == false:
				$tempo_invencivel.start()
				hit()
				hp -= 10
				emit_signal("levarDano", 10)
			else:
				area.get_owner().call_deferred("explodir")
				motion.y = -(JUMP / 2)
				$pulo.play()
				emit_signal("aumentarScore", 50)
	pass

# Called when player is hit
func hit():
	# Color transition
	$Tween.interpolate_property(
		$Sprite, 
		"modulate", 
		Color(0.55, 0, 0, 1), 
		Color(1, 1, 1, 1), 
		.5, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_IN_OUT
	)
	# Size transition
	$Tween.interpolate_property(
		$Sprite, 
		"scale", 
		Vector2(0.5, 0.5), 
		Vector2(1, 1), 
		.5, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_IN_OUT
	)
	
	# Enemy direction
	var direction
	if objetoInimigo != null:
		if objetoInimigo.direcaoInimigo == -1:
			direction = Vector2(position.x - 30, position.y)
		else:
			direction = Vector2(position.x + 30, position.y)
				
		$Tween.interpolate_property(
			self,
			"position",
			Vector2(position.x, position.y),
			direction,
			.5, 
			Tween.TRANS_BOUNCE, 
			Tween.EASE_IN_OUT
		)
		
		# Start tween
		$dano.play()
		$Tween.start()
	pass
	
# Called when jump on head of enemy
func _on_areaBater_area_entered(area):
	if area.is_in_group("inimigo"):
		colisorDano = true
	pass
	
# Called when exited of enemy area	
func _on_areaBater_area_exited(area):
	if area.is_in_group("inimigo"):
		colisorDano = false
	pass
	