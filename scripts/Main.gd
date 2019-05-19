extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Personagem.connect("levarDano", $guiCanvas/GUI, "damage")
	$Personagem.connect("aumentarScore", $guiCanvas/GUI, "addScore")
	$Chest.connect("openChest", $guiCanvas/GUI, "addGold")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
