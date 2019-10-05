extends "res://entities/actors/actor.gd"

enum state {enter, hunt}

const spriteSize = 16

var currentState = null

onready var spawnPosition = self.position

func _ready():
	currentState = state.enter
	speed = 32

func _physics_process(delta):
	if currentState == state.enter:
		if direction.x == 1 && self.position.x >= (spawnPosition.x + spriteSize * 2):
			currentState = state.hunt
		elif direction.x == -1 && self.position.x <= (spawnPosition.x - spriteSize * 2):
			currentState = state.hunt
		elif direction.y == 1 && self.position.y >= (spawnPosition.y + spriteSize * 2):
			currentState = state.hunt
		elif direction.y == -1 && self.position.y <= (spawnPosition.y - spriteSize * 2):
			currentState = state.hunt
		else:
			move(delta)

	elif currentState == state.hunt:
		direction = Vector2()


