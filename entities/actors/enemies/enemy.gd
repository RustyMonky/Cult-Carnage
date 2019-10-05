extends "res://entities/actors/actor.gd"

enum state {enter, hunt}

const spriteSize = 16

var currentState = null

onready var projectileTimer = $projectileTimer
onready var spawnPosition = self.position

func _ready():
	currentState = state.enter
	hp = 1
	speed = 32

	projectileTimer.set_wait_time(2.00)

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

		if !get_parent().has_node("player"):
			return

		look_at(get_parent().get_node("player").get_global_position())

		if projectileTimer.is_stopped():
			projectileTimer.start()

# Upon timeout, fire a projectile
# Eventually, enemies will fire specific projectiles. For now, use the test one.
func _on_projectileTimer_timeout():
	if !get_parent().has_node("player"):
		projectileTimer.stop()
		return

	var projectile = load("res://entities/projectiles/projectile.tscn").instance()
	projectile.direction = self.position.direction_to(get_parent().get_node("player").get_global_position())
	projectile.position = self.position
	get_parent().add_child(projectile)

# Enemy death logic, which can contain item drops or hazards
func death():
	var weaponToDrop = load("res://entities/collectibles/weapons/weapon.tscn").instance()
	weaponToDrop.global_position = self.global_position
	get_parent().add_child(weaponToDrop)
	self.queue_free()
