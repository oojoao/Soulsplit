extends Enemy

export var spike : PackedScene

func enemy_action():
	var newSpike = spike.instance()
	bottomEnemiesManager.add_child(newSpike)
	if elite:
		newSpike.modulate = modulate
	newSpike.global_position = get_spawn_position()
