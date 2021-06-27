extends KinematicBody2D

onready var gameManager = get_node("../../GameManager")
onready var UI = get_node("../../UI")
onready var animPlayer = $AnimationTree.get("parameters/playback")
onready var invincibleTimer = $InvincibleTimer
onready var sprite = $Sprite

var inputVector = Vector2.ZERO
var speed = 200
var velocity
var invincible = false
var jumpAnim = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and InputMap.action_has_event("jump", event) and invincible == false:
			gameManager.sfxJump.play()
			start_invincibility()
			jumpAnim = true

func _physics_process(_delta):
	if jumpAnim:
		animPlayer.travel("Jump")
	else:
		animPlayer.travel("Idle")
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	velocity = inputVector * speed
	velocity = move_and_slide(velocity)

	global_position.x = clamp(global_position.x, UI.playerBoundaries.rect_global_position.x, UI.playerBoundaries.rect_global_position.x + UI.playerBoundaries.rect_size.x)
	global_position.y = clamp(global_position.y, UI.playerBoundaries.rect_global_position.y, UI.playerBoundaries.rect_global_position.y + UI.playerBoundaries.rect_size.y)

func take_damage():
	var hitEffect = gameManager.hitEffect.instance()
	hitEffect.gameManager = gameManager
	hitEffect.move = true
	gameManager.add_child(hitEffect)
	hitEffect.global_position = global_position
	gameManager.take_damage()
	start_invincibility()

func start_invincibility(time = 0.5):
	sprite.modulate.a = 0.2
	$CollisionShape2D.set_deferred("disabled", true)
	speed = 300
	invincibleTimer.start(time)
	invincible = true

func _on_InvincibleTimer_timeout():
	if jumpAnim:
		jumpAnim = false
	sprite.modulate.a = 1.0
	$CollisionShape2D.set_deferred("disabled", false)
	speed = 200
	yield(get_tree().create_timer(0.5), "timeout")
	invincible = false
