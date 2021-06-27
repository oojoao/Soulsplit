extends Control

onready var playerBoundaries = $BottomScreen/PlayerBoundaries
onready var groundEnemySpawn = $BottomScreen/GroundSpawn
onready var infiniteFloor = $BottomScreen/Floor
onready var gameManager = get_node("../GameManager")

var speed
var dupeFloor

func _ready():
	dupeFloor = infiniteFloor.duplicate()
	$BottomScreen.add_child(dupeFloor)
	dupeFloor.rect_position.x += infiniteFloor.rect_size.x

func _process(_delta):
	speed = gameManager.speed
	
	for rollingFloor in [dupeFloor, infiniteFloor]:
		rollingFloor.rect_position.x -= speed
		var floorWidth = rollingFloor.rect_size.x * rollingFloor.rect_scale.x
		if rollingFloor.rect_position.x <= (-floorWidth):
			rollingFloor.rect_position.x += 2 * floorWidth
