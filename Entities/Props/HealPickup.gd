extends PowerUp

func powerup_action():
	gameManager.health += 1
	if gameManager.health > 3:
		gameManager.health = 3
	UI.update_health()
