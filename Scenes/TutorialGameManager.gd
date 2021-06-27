extends Node

onready var topEnemiesManager = get_node("../TopEnemies")
onready var bottomEnemiesManager = get_node("../BottomEnemies")
onready var UI = get_node("../UI")
onready var topPlayer = get_node("../Units/TopPlayer")
onready var bottomPlayer = get_node("../Units/BottomPlayer")

onready var sfxPickup = get_node("../Pickup")
onready var sfxHit = get_node("../Hit")
onready var sfxJump = get_node("../Jump")
onready var music = get_node("../Music")

export var hitEffect : PackedScene
export var powerUpPool = []

var powerUpQueue = []
var powerUpColor = [Color(1.0,1.0,1.0), Color(1.0,0.0,0.0), Color(0.0,0.8,0.8), Color(0.0,1.0,0.0)]
var currentLeftEnemies = []
var currentRightEnemies = []

var killCount = 0
var powerUpCounter = 0
var speed = 2.0
var health = 3
var score = 0.0

func _ready():
	topPlayer.global_position = UI.get_node("TopScreen/PlayerSpot").rect_global_position

func take_damage():
	sfxHit.play()

func _on_PowerUpPool_timeout():
	randomize()
	var newPowerUp
	newPowerUp = powerUpPool[randi() % powerUpPool.size()].instance()
	bottomEnemiesManager.add_child(newPowerUp)
	newPowerUp.global_position = Vector2(UI.groundEnemySpawn.rect_global_position.x, UI.groundEnemySpawn.rect_global_position.y + (randi() % 5) * 32)


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
