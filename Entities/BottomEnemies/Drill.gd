extends KinematicBody2D

onready var gameManager = get_node("../../GameManager")
onready var moveTimer = $MoveTimer
onready var prepTimer = $PreparationTimer
var velocity = Vector2.ZERO
var direction

func _process(delta):
	if prepTimer.time_left != 0:
		if delta != 0:
			velocity = (0.5 / delta) * Vector2.DOWN
		# warning-ignore:return_value_discarded
		move_and_slide(velocity)
	if moveTimer.time_left == 0:
		if delta != 0:
			velocity = (2 * gameManager.speed / delta) * direction
		else: 
			velocity = (2 * gameManager.speed / 0.16666667) * direction
		# warning-ignore:return_value_discarded
		move_and_slide(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_DamageArea_body_entered(body):
	if body.name == "BottomPlayer":
		body.take_damage()

func _on_MoveTimer_timeout():
	direction = global_position.direction_to(gameManager.bottomPlayer.global_position)
	look_at(gameManager.bottomPlayer.global_position)
	rotation *= -1
	print(rotation_degrees)
