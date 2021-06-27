extends KinematicBody2D

onready var gameManager = get_node("../../GameManager")
onready var attackCooldown = $AttackCooldown
onready var animPlayer = $AnimationTree.get("parameters/playback")
onready var sprite = $Sprite
onready var invincibleTimer = $InvincibleTimer

var side = true
var targetList = []
var currentTarget
var attackAvailable = true
var jumpAnim = false
var invincible = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and InputMap.action_has_event("change_side", event):
			side = !side
		if event.pressed and InputMap.action_has_event("jump", event) and invincible == false:
			jumpAnim = true
			invincibleTimer.start(0.5)
			invincible = true

func _physics_process(_delta):
	if jumpAnim:
		animPlayer.travel("Jump")
	else:
		animPlayer.travel("Idle")
	sprite.flip_h = !side
	$Sprite/Swords/SwordLeft.visible = !side
	$Sprite/Swords/SwordRight.visible = side
	
func attack_enemy(damage):
	if side:
		if !gameManager.currentRightEnemies.empty():
			currentTarget = gameManager.currentRightEnemies.front()
		elif !gameManager.currentLeftEnemies.empty():
			side = !side
			currentTarget = gameManager.currentLeftEnemies.front()
	else:
		if !gameManager.currentLeftEnemies.empty():
			currentTarget = gameManager.currentLeftEnemies.front()
		elif !gameManager.currentRightEnemies.empty():
			side = !side
			currentTarget = gameManager.currentRightEnemies.front()
	if is_instance_valid(currentTarget):
		currentTarget.take_damage(damage)
		attackAvailable = false
		attackCooldown.start()

func attack_side(damage):
	if side:
		if !gameManager.currentRightEnemies.empty():
			for enemy in gameManager.currentRightEnemies:
				if enemy != null:
					enemy.take_damage(damage)
		else:
			side = !side
			for enemy in gameManager.currentLeftEnemies:
				if enemy != null:
					enemy.take_damage(damage)
	else:
		if !gameManager.currentLeftEnemies.empty():
			for enemy in gameManager.currentLeftEnemies:
				if enemy != null:
					enemy.take_damage(damage)
		else:
			side = !side
			for enemy in gameManager.currentRightEnemies:
				if enemy != null:
					enemy.take_damage(damage)

func _on_AttackCooldown_timeout():
	attackAvailable = true

func start_invincibility(time = 0.5):
	sprite.modulate.a = 0.2
	$CollisionShape2D.set_deferred("disabled", true)
	invincibleTimer.start(time)
	invincible = true
	
func take_damage():
	var hitEffect = gameManager.hitEffect.instance()
	hitEffect.gameManager = gameManager
	gameManager.add_child(hitEffect)
	hitEffect.global_position = global_position
	gameManager.take_damage()
	start_invincibility()
	
func _on_InvincibleTimer_timeout():
	if jumpAnim:
		jumpAnim = false
	sprite.modulate.a = 1.0
	yield(get_tree().create_timer(0.5), "timeout")
	invincible = false

func sort_targets(a, b):
	if a.global_position.distance_to(self.global_position) < b.global_position.distance_to(self.global_position):
		return true
	return false
