extends KinematicBody2D

var gameManager
var move = false

func _ready():
	$AnimationPlayer.play("Effect")

func _process(_delta):
	if move:
		var velocity = (gameManager.speed / 0.0166666667) * Vector2.LEFT
		
		# warning-ignore:return_value_discarded
		move_and_slide(velocity)
	
func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
