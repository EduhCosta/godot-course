extends StaticBody2D

# Variables
var areaDetectavel = false
var objetoPersonagem
var direcaoInimigo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Character enter on areaInimigo
	$areaInimigo.connect("body_entered", self, "_on_areaInimigo_body_entered")
	
	# Character leave on areaInimigo
	$areaInimigo.connect("body_exited", self, "_on_areaInimigo_body_exited")
	
	# Start enimy animation
	$AnimationPlayer.play("paradoEsquerda")
	
	# Connection animation player
	$AnimationPlayer.connect("animation_finished", self, "endAnimation")
	
	# Conect detroyer time
	$destroy_timer.connect("timeout", self, "destroyer")
	pass 

func _on_areaInimigo_body_entered(body):
	if (body.is_in_group("personagem")):
		objetoPersonagem = body
		body.objetoInimigo = self
		areaDetectavel = true
	pass
	
func _on_areaInimigo_body_exited(body):
	if (body.is_in_group("personagem")):
		objetoPersonagem = null
		body.objetoInimigo = null
		areaDetectavel = false
	pass
	
func _physics_process(delta):
	if (areaDetectavel):
		meetCharacter()
		if (objetoPersonagem != null):
			identifySide(objetoPersonagem)
	pass

# Start correct animation on character side
func meetCharacter():
	if (
		$AnimationPlayer.current_animation != "ataqueDireita" 
		|| $AnimationPlayer.current_animation != "ataqueEsquerda" 
	):
		if ($Sprite.flip_h == false):
			$AnimationPlayer.play("ataqueEsquerda")
		else:
			$AnimationPlayer.play("ataqueDireita")
	pass

# Intentify if character enter on enemy area
func identifySide(body):
	if (body.position.x < position.x):
		changeSide(false)
	else:
		changeSide(true)
	pass

# Change enemy view direction
func changeSide(dir):
	if (dir):
		direcaoInimigo = 1
	else:
		direcaoInimigo = -1
	
	# Change sprite side
	$Sprite.flip_h = dir
	pass

# Finish animation
func endAnimation(anim):
	if anim == "ataqueDireita" || anim == "ataqueEsquerda":
		if ($Sprite.flip_h == false):
			$AnimationPlayer.play("paradoEsquerda")
		else:
			$AnimationPlayer.play("paradoDireita")
	pass
	
func explodir():
	$Tween.interpolate_property(
		$Sprite, 
		"modulate", 
		Color(1, 1, 1, 1), 
		Color(1, 1, 1, 0), 
		.5, 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	$explodir.play()
	
	$Particles2D.emitting = true
	
	$destroy_timer.start()
	pass
	
func destroyer():
	queue_free()
	pass
	