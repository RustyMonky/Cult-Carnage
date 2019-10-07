extends Node2D

# This node assumes that it is a child of the level root node!

const spriteSize = 16

onready var timer = $timer
onready var viewport = get_parent().get_node("viewport") # Assumes the level has a Viewport child called "viewport"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_timer_timeout():
	if !get_parent().has_node("player"):
		timer.stop()
		return

	randomize()
	var enemyToLoad = int(rand_range(0, gameData.enemies.size()))

	var spawn = load(gameData.enemies[enemyToLoad].path).instance()
	var spawnHeight = int(rand_range(spriteSize, viewport.size.y - spriteSize * 2))
	var spawnWidth = int(rand_range(spriteSize, viewport.size.x - spriteSize * 2))

	var sideId = randi() % 3

	if sideId == 0:
		spawn.position = Vector2(-spriteSize, spawnHeight)
		spawn.direction = Vector2(1, 0)
	elif sideId == 1:
		spawn.position = Vector2(spawnWidth, -spriteSize)
		spawn.direction = Vector2(0, 1)
	elif sideId == 2:
		spawn.position = Vector2(viewport.size.x + spriteSize, spawnHeight)
		spawn.direction = Vector2(-1, 0)
	elif sideId == 3:
		spawn.position = Vector2(viewport.size.y + spriteSize, spawnWidth)
		spawn.direction = Vector2(0, -1)

	get_parent().add_child(spawn)
