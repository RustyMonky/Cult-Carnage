extends "res://entities/actors/actor.gd"

enum state {enter, hunt}

const spriteSize = 16

var currentState
var droppedWeapon
var droppedWeaponType
var usedProjectile

onready var projectileTimer = $projectileTimer
onready var enemyRay = $enemyRay
onready var spawnPosition = self.position
onready var silhuoette = $silhouette

func _ready():
	currentState = state.enter
	hp = 1
	speed = 32
	usedProjectile = "res://entities/projectiles/projectile.tscn"
	droppedWeapon = "res://entities/collectibles/weapons/weapon.tscn"
	droppedWeaponType = 'test-gun'
	look_at(get_parent().get_node("player").get_global_position())

	projectileTimer.set_wait_time(3.00)

func _physics_process(delta):
	if currentState == state.enter:
		if enemyRay.is_colliding() && enemyRay.get_collider().is_in_group('enemies'):
			return
		elif direction.x == 1 && self.position.x >= (spawnPosition.x + spriteSize * 2):
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
func _on_projectileTimer_timeout():
	fire()

# Enemy death logic, which can contain item drops or hazards
func death():
	randomize()

	var randomChance = int(rand_range(0, 2))
	if randomChance > 0:
		var weaponToDrop = load(droppedWeapon).instance()
		weaponToDrop.type = droppedWeaponType
		weaponToDrop.global_position = self.global_position
		get_parent().call_deferred('add_child', weaponToDrop)

	gameData.enemiesKilled += 1
	.death()

func fire():
	if !get_parent().has_node("player") || self.hp == 0:
		projectileTimer.stop()
		return
	.fire()

	var projectile = load(usedProjectile).instance()
	projectile.direction = self.position.direction_to(get_parent().get_node("player").get_global_position())
	projectile.position = self.position
	get_parent().add_child(projectile)
	if droppedWeaponType == 'test-gun':
		animationPlayer.play("test-enemy-fire")

# In addition to standard logic, blink the sprite white
func takeDamage():
	# Blink white by toggling silhuoette visibility
	tween.interpolate_property(silhuoette, "visible", true, false, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

	.takeDamage()
