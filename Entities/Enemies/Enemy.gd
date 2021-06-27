class_name Enemy
extends KinematicBody2D

onready var gameManager = get_node("../../GameManager")
onready var UI = get_node("../../UI")
onready var bottomEnemiesManager = gameManager.bottomEnemiesManager
onready var actionTimer = $ActionTimer
onready var sprite = $Sprite

export var enemyLifeScene : PackedScene
export var type = "ground"

var enemyLife
var eliteChance = 15
var elite = false
var carriedPowerUp
var health = 4
var side = 0
var timeFactor
var actionSpeed = 1

func _ready():
	enemy_ready()
	
func enemy_action():
	pass
	
func enemy_ready():
	enemyLife = enemyLifeScene.instance()
	add_child(enemyLife)
	
	actionSpeed = actionTimer.wait_time
	_on_ActionTimer_timeout()

func _on_ActionTimer_timeout():
	enemy_action()
	timeFactor = actionSpeed / (gameManager.speed / 2)
	if timeFactor < 0.2:
		timeFactor = 0.2
	actionTimer.start(actionSpeed * timeFactor)
	
func take_damage(amount):
	var hitEffect = gameManager.hitEffect.instance()
	hitEffect.gameManager = gameManager
	gameManager.add_child(hitEffect)
	hitEffect.global_position = global_position
	health -= amount
	sprite.modulate.a = 0.2
	
	gameManager.sfxHit.play()
	
	enemyLife.health = health
	
	if health <= 0:
		gameManager.killCount += 1
		if side == 1:
			gameManager.currentRightEnemies.remove(0)
			for x in gameManager.currentRightEnemies:
				x.move_after_kill()
		else:
			gameManager.currentLeftEnemies.remove(0)
			for x in gameManager.currentLeftEnemies:
				x.move_after_kill()
		if carriedPowerUp != null:
			gameManager.powerUpQueue.append(carriedPowerUp)
		queue_free()
		
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		sprite.modulate.a = 1

func move_after_kill():
	yield(get_tree().create_timer(0.3),"timeout")
	if side == 1:
		global_position.x -= 128
	else:
		global_position.x += 128

func get_spawn_position():
	var position = Vector2.ZERO
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if type == "air":
		position = Vector2(UI.airEnemySpawn.rect_global_position.x + (rng.randi() % 10) * 32, UI.airEnemySpawn.rect_global_position.y)
	else:
		position = Vector2(UI.groundEnemySpawn.rect_global_position.x, UI.groundEnemySpawn.rect_global_position.y + (rng.randi() % 6) * 32)
	return position

func check_elite_chance():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if (rng.randi_range(1, 99)) < eliteChance:
		return true
	return false
