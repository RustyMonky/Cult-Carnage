extends "res://entities/actors/actor.gd"

enum state {enter, hunt}

const spriteSize = 16

var currentState = null

onready var projectileTimer = $projectileTimer
onready var spawnPosition = self.position
onready var silhuoette = $silhouette

func _ready():
	currentState = state.enter
	hp = 2
	speed = 32
	look_at(get_parent().get_node("player").get_global_position())

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
	if !get_parent().has_node("player") || self.hp == 0:
		projectileTimer.stop()
		return

	var projectile = load("res://entities/projectiles/projectile.tscn").instance()
	projectile.direction = self.position.direction_to(get_parent().get_node("player").get_global_position())
	projectile.position = self.position
	get_parent().add_child(projectile)
	animationPlayer.play("test-enemy-fire")

# Enemy death logic, which can contain item drops or hazards
func death():
	randomize()

	var randomChance = int(rand_range(0, 2))
	if randomChance > 0:
		var weaponToDrop = load("res://entities/collectibles/weapons/weapon.tscn").instance()
		weaponToDrop.global_position = self.global_position
		get_parent().call_deferred('add_child', weaponToDrop)

	gameData.enemiesKilled += 1
	.death()

# In addition to standard logic, blink the sprite white
func takeDamage():
	# Blink white by toggling silhuoette visibility
	tween.interpolate_property(silhuoette, "visible", true, false, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

	.takeDamage()
