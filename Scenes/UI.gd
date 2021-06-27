extends Control

onready var playerBoundaries = $BottomScreen/PlayerBoundaries
onready var groundEnemySpawn = $BottomScreen/GroundSpawn
onready var airEnemySpawn = $BottomScreen/AirSpawn
onready var infiniteFloor = $BottomScreen/Floor
onready var gameManager = get_node("../GameManager")

export var heartTextRect : PackedScene
var speed
var dupeFloor

func _ready():
	dupeFloor = infiniteFloor.duplicate()
	$BottomScreen.add_child(dupeFloor)
	dupeFloor.rect_position.x += infiniteFloor.rect_size.x
	update_health()

func update_health():
	for x in $Lives.get_children():
		x.queue_free()
	for x in range(0, gameManager.health):
		var newHeart = heartTextRect.instance()
		$Lives.add_child(newHeart)
		newHeart.rect_global_position = Vector2(110 + (x * 36), 12)

func _process(_delta):
	$Score.text = "Score: " + str(ceil(gameManager.score))
#	$Lives.text = "Lives: " + str(gameManager.health)
	speed = gameManager.speed
	
	for rollingFloor in [dupeFloor, infiniteFloor]:
		rollingFloor.rect_position.x -= speed
		var floorWidth = rollingFloor.rect_size.x * rollingFloor.rect_scale.x
		if rollingFloor.rect_position.x <= (-floorWidth):
			rollingFloor.rect_position.x += 2 * floorWidth

func top_enemy_spawn(enemy):
	if enemy.type == "air":
		if enemy.side == 0:
			return $TopScreen/LeftSpawn/AirSpawn
		if enemy.side == 1:
			return $TopScreen/RightSpawn/AirSpawn
	else:
		if enemy.side == 0:
			return $TopScreen/LeftSpawn/GroundSpawn
		if enemy.side == 1:
			return $TopScreen/RightSpawn/GroundSpawn
