extends Control

# Variables
var currentScore = 0

func _ready():
	pass 

func damage(dano):
	$ProgressBar.value -= dano
	pass
	
func addScore(score):
	currentScore += score
	$score.text = "Score: " + str(currentScore)
	pass
