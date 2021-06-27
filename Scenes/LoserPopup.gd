extends Control

onready var distance = $Panel/Distance
onready var kills = $Panel/Kills
onready var powerups = $Panel/Powerups
onready var score = $Panel/Score
var distanceTravelled setget set_distance
var killCount setget set_kills
var powerUpCount setget set_powerups
var finalScore setget set_final_score

func _on_Play_pressed():
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_Quit_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func set_distance(value):
	distanceTravelled = value
	distance.text = "DISTANCE TRAVELLED:        " + str(distanceTravelled) + "m"

func set_kills(value):
	killCount = value
	kills.text = "Enemies Killed: " + str(killCount) + "           x100"

func set_powerups(value):
	powerUpCount = value
	powerups.text = "Picked powerups: " + str(powerUpCount) + "          x10"

func set_final_score(value):
	finalScore = value
	score.text = "Final Score: " + str(finalScore)
