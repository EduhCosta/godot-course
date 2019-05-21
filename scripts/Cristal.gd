extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("basic")
	$cristalArea.connect("body_entered", self, "_on_cristal_area_body_entered")
	pass 

func _on_cristal_area_body_entered(area):
	if area.is_in_group("personagem"):
		queue_free()
	pass