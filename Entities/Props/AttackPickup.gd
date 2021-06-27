extends PowerUp

func powerup_action():
	gameManager.topPlayer.attack_enemy(2)
