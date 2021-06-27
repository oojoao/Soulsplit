extends Enemy

export var drill : PackedScene

func enemy_action():
	var newDrill = drill.instance()
	bottomEnemiesManager.add_child(newDrill)
	if elite:
		newDrill.modulate = modulate
	newDrill.moveTimer.start()
	newDrill.global_position = get_spawn_position()
