class_name PowerUp
extends KinematicBody2D

onready var gameManager = get_node("../../GameManager")
onready var UI = gameManager.UI
onready var sprite = $Sprite
var velocity

func _process(_delta):
	velocity = (gameManager.speed / 0.0166666667) * Vector2.LEFT
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_DamageArea_body_entered(body):
	if body.name == "BottomPlayer":
		gameManager.powerUpCounter += 1
		gameManager.sfxPickup.play()
		powerup_action()
		queue_free()

func powerup_action():
	pass
