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
export var losePopup : PackedScene
export var enemyPool = []
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

func _process(delta):
	score += delta * speed * 5

func take_damage():
	sfxHit.play()
	health -= 1
	UI.update_health()
	if health <= 0:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().paused = true
		var newPopup = losePopup.instance()
		add_child(newPopup)
		newPopup.distanceTravelled = ceil(score)
		newPopup.killCount = ceil(killCount)
		newPopup.powerUpCount = ceil(powerUpCounter)
		newPopup.finalScore = ceil(score + (powerUpCounter * 10) + (killCount * 100))

func _on_DifficultyTimer_timeout():
	if speed >= 50:
		speed = 50
	else:
		speed += 0.3
	
	var wait_time = $Spawner.wait_time
	if wait_time <= 1.0:
		$Spawner.wait_time = 1.0
	else:
		$Spawner.wait_time -= 0.1
	
func _on_Spawner_timeout():
	if currentLeftEnemies.size() != 3 or currentRightEnemies.size() != 3:
		var spawnEnemy = enemyPool[randi() % enemyPool.size()].instance()
		spawnEnemy.elite = spawnEnemy.check_elite_chance()
		if spawnEnemy.elite:
			spawnEnemy.health *= 2
			var powerUpCount = (randi() % (powerUpPool.size() - 1)) + 1
			spawnEnemy.carriedPowerUp = powerUpPool[powerUpCount]
			spawnEnemy.modulate = powerUpColor[powerUpCount]
		
		if currentLeftEnemies.size() < 3 and currentRightEnemies.size() < 3:
			randomize()
			spawnEnemy.side = randi() % 2
		elif currentLeftEnemies.size() == 3 and currentRightEnemies.size() < 3:
			spawnEnemy.side = 1
		elif currentRightEnemies.size() == 3 and currentLeftEnemies.size() < 3:
			spawnEnemy.side = 0

		var spawnPosition = UI.top_enemy_spawn(spawnEnemy).rect_global_position
		topEnemiesManager.add_child(spawnEnemy)
		if spawnEnemy.side == 0:
			currentLeftEnemies.append(spawnEnemy)
			spawnPosition.x -= (currentLeftEnemies.size() - 1) * 128
		else:
			currentRightEnemies.append(spawnEnemy)
			spawnEnemy.sprite.flip_h = true
			spawnPosition.x += (currentRightEnemies.size() - 1) * 128
		spawnEnemy.global_position = spawnPosition

func _on_PowerUpPool_timeout():
	randomize()
	var newPowerUp
	if powerUpQueue.empty():
		newPowerUp = powerUpPool[0].instance()
	else:
		var queuePop = powerUpQueue.pop_front()
		newPowerUp = queuePop.instance()
	bottomEnemiesManager.add_child(newPowerUp)
	newPowerUp.global_position = Vector2(UI.groundEnemySpawn.rect_global_position.x, UI.groundEnemySpawn.rect_global_position.y + (randi() % 5) * 32)


func _on_Music_finished():
	music.play()
