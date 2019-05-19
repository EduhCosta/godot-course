extends StaticBody2D

# Signals
signal openChest

# Variables
var canOpen = false
var isOpened = false

func _ready():
	$openChest.connect("body_entered", self, "_on_open_chest_body_entered")
	$openChest.connect("body_exited", self, "_on_open_chest_body_exited")
	pass 

func _process(delta):
	if (canOpen):
		if (Input.is_action_just_pressed("open_chest")):
			$AnimationPlayer.play("openFront")
			isOpened = true
			$openText.visible = false
			emit_signal("openChest", randi()%150+100)
	pass
	
func _on_open_chest_body_entered(body):
	if (body.is_in_group("personagem") && isOpened == false):
		$AnimationPlayer.play("haveItem")
		$openText.visible = true
		canOpen = true
	pass

func _on_open_chest_body_exited(body):
	if (body.is_in_group("personagem") && $AnimationPlayer.current_animation == "haveItem"):
		$AnimationPlayer.stop(false)
		$openText.visible = false
		canOpen = false
	pass