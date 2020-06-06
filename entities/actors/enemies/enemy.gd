extends "res://entities/actors/actor.gd"

enum state {enter, hunt, advance}

const spriteSize = 16

var currentState
var droppedWeapon
var droppedWeaponType
var isTutorial = false
var lastStandingPostion = Vector2()
var textToSpeak = ''
var usedProjectile

onready var delayTimer = $delayTimer
onready var enemyRay = $enemyRay
onready var moveTimer = $moveTimer
onready var projectileTimer = $projectileTimer
onready var spawnPosition = self.position
onready var speechLabel = $canvas/speechLabel
onready var silhuoette = $silhouette
onready var textTimer = $textTimer

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
		elif direction.x == 1 && self.global_position.x >= (spawnPosition.x + spriteSize * 2):
			currentState = state.hunt
		elif direction.x == -1 && self.global_position.x <= (spawnPosition.x - spriteSize * 2):
			currentState = state.hunt
		elif direction.y == 1 && self.global_position.y >= (spawnPosition.y + spriteSize * 2):
			currentState = state.hunt
		elif direction.y == -1 && self.global_position.y <= (spawnPosition.y - spriteSize * 2):
			currentState = state.hunt
		else:
			move(delta)

	elif currentState == state.advance:
		if !projectileTimer.is_stopped():
			projectileTimer.stop()
		if direction.x == 1 && self.global_position.x >= (lastStandingPostion.x + spriteSize * 2):
			currentState = state.hunt
		elif direction.x == -1 && self.global_position.x <= (lastStandingPostion.x - spriteSize * 2):
			currentState = state.hunt
		elif direction.y == 1 && self.global_position.y >= (lastStandingPostion.y + spriteSize * 2):
			currentState = state.hunt
		elif direction.y == -1 && self.global_position.y <= (lastStandingPostion.y - spriteSize * 2):
			currentState = state.hunt
		else:
			move(delta)

	elif currentState == state.hunt:
		direction = Vector2()
		if moveTimer.is_stopped():
			moveTimer.wait_time = 10.00
			moveTimer.start()

		if !get_parent().has_node("player"):
			return

		look_at(get_parent().get_node("player").get_global_position())

		if projectileTimer.is_stopped() && !isTutorial:
			projectileTimer.start()

# Upon timeout, fire a projectile
func _on_projectileTimer_timeout():
	fire()

# Enemy death logic, which can contain item drops or hazards
func death():
	if (!isTutorial):
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

# Publicly accessible function to allow cultists to speak
func setSpeech(words):
	speechLabel.visible_characters = 0
	textToSpeak = words
	speechLabel.set_bbcode(words)
	textTimer.start()

# In addition to standard logic, blink the sprite white
func takeDamage():
	# Blink white by toggling silhuoette visibility
	tween.interpolate_property(silhuoette, "visible", true, false, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

	.takeDamage()

func _on_moveTimer_timeout():
	lastStandingPostion = self.global_position
	currentState = state.advance

func _on_textTimer_timeout():
	if speechLabel.visible_characters == textToSpeak.length():
		textTimer.stop()
		delayTimer.start()
	else:
		speechLabel.visible_characters += 1

func _on_delayTimer_timeout():
	speechLabel.visible_characters = 0
	speechLabel.set_text('')
	delayTimer.stop()
