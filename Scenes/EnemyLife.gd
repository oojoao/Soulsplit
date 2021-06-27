extends Control

onready var elite = get_parent().elite
var health setget set_health

func set_health(value):
	health = value
	if elite:
		$ReferenceRect/Health.rect_size.x = 5 * health
	else:
		$ReferenceRect/Health.rect_size.x = 10 * health
