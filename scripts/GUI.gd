extends Control

# Variables
var currentScore = 0
var currentGold = 0

func _ready():
	pass 

func damage(dano):
	$ProgressBar.value -= dano
	pass
	
func addScore(score):
	currentScore += score
	$score.text = "Score: " + str(currentScore)
	pass
	
func addGold(gold):
	currentGold += gold
	$gold.text = "Gold: " + str(currentGold)
	pass
