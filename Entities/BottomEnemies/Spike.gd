extends KinematicBody2D

onready var gameManager = get_node("../../GameManager")
var velocity

func _physics_process(delta):
	if delta != 0:
		velocity = (gameManager.speed / delta) * Vector2.LEFT
	else:
		velocity = (gameManager.speed / 0.16666667) * Vector2.LEFT
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_DamageArea_body_entered(body):
	if body.name == "BottomPlayer":
		body.take_damage()
