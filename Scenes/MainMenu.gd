extends Control

func _ready():
	$GameOpening.play()

func _on_Button_pressed():
	$UI_Accept.play()
	get_tree().paused = true
	yield(get_tree().create_timer(0.2),"timeout")
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_Quit_pressed():
	$UI_Accept.play()
	get_tree().paused = true
	yield(get_tree().create_timer(0.2),"timeout")
	get_tree().paused = false
	get_tree().quit()

func _on_Tutorial_pressed():
	$UI_Accept.play()
	get_tree().paused = true
	yield(get_tree().create_timer(0.2),"timeout")
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Tutorial.tscn")
	
