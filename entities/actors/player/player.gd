extends "res://entities/actors/actor.gd"

onready var aliveTimer = $aliveTimer
onready var ammoWarning = $canvas/warning
onready var cbox = $canvas/centerBox
onready var equippedWeapon = $canvas/centerBox/hbox/icon
onready var equippedWeaponAmmoCount = $canvas/centerBox/hbox/ammo
onready var hpBar = $canvas/centerBox/hbox/hp
onready var punchRaycast = $rayPunch

var currentWeaponIndex = 0
var inventory = [{'type': 'punch'}]
var viewport

func _ready():
	cbox.modulate = Color(1, 1, 1, 0.7)
	speed = 48
	hp = 5
	hpBar.max_value = hp
	hpBar.value = hp

	# Assumes viewport exists on parent
	viewport = get_parent().get_node("viewport")

func _input(event):
	if hp <= 0:
		return

	if event.is_action_pressed("player_attack"):
		if currentWeaponIndex == 0: # Index 0 will always be the starting punch weapon

			if animationPlayer.is_playing():
				return
			else:
				animationPlayer.play("punch")

			if punchRaycast.is_colliding() && punchRaycast.get_collider().is_in_group("enemies"):
				punchRaycast.get_collider().takeDamage()
		else:
			fire()

	if event.is_action_pressed("player_scroll_left"):
		if currentWeaponIndex == 0:
			return
		currentWeaponIndex -= 1
		swapWeapons()

	elif event.is_action_pressed("player_scroll_right"):
		if currentWeaponIndex == inventory.size() -1:
			return
		currentWeaponIndex += 1
		swapWeapons()

func _physics_process(delta):
	if hp <= 0:
		return

	punchRaycast.look_at(get_global_mouse_position())
	sprite.look_at(get_global_mouse_position())

	if Input.is_action_pressed("player_up"):
		direction.y = -1
		if self.position.y - 8 <= 0:
			direction.y = 0
		move(delta)
	elif Input.is_action_pressed("player_down"):
		direction.y = 1
		if self.position.y + 8 >= viewport.size.y:
			direction.y = 0
		move(delta)
	else:
		direction.y = 0

	if Input.is_action_pressed("player_left"):
		direction.x = -1
		if self.global_position.x - 8 <= 0:
			direction.x = 0
		move(delta)
	elif Input.is_action_pressed("player_right"):
		direction.x = 1
		if self.global_position.x + 8 >= viewport.size.x:
			direction.x = 0
		move(delta)
	else:
		direction.x = 0

# Logic to add ammo and weapons to the player's inventory
func addToInventory(weaponData):
	for weapon in inventory:
		if weapon.type == weaponData.type:
			weapon.ammo.count += weaponData.ammo.count
			if weaponData.type == inventory[currentWeaponIndex].type:
				equippedWeaponAmmoCount.set_text("x" + String(inventory[currentWeaponIndex].ammo.count))
			return

	inventory.append(weaponData)
	sprite.set_frame(sprite.hframes * currentWeaponIndex)

	# If currently punching, equip the gun
	if currentWeaponIndex == 0 && inventory.size() == 2:
		currentWeaponIndex = 1
		swapWeapons()

func death():
	gameData.playerAlive = false
	aliveTimer.stop()
	.death()

# Eventually, this will need to support multiple projectile types
func fire():
	if inventory[currentWeaponIndex].ammo.count == 0:
		ammoWarning.visible = true
		tween.interpolate_property(ammoWarning, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.5, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
		tween.start()
		return
	.fire()

	var projectile = load("res://entities/projectiles/projectile.tscn").instance()
	var projectileTexture = load("res://assets/projectiles/" + inventory[currentWeaponIndex].ammo.type + ".png")

	projectile.direction = self.position.direction_to(get_global_mouse_position())
	projectile.position = self.position
	projectile.get_node("sprite").set_texture(projectileTexture)
	projectile.collision_layer = 2 # This will allow it to collide with enemies!
	projectile.collision_mask = 1 # This will allow it to collide with enemies!
	projectile.modulate = Color("#51c43f");

	get_parent().add_child(projectile)
	projectile.speed = 64*4
	inventory[currentWeaponIndex].ammo.count -= 1
	equippedWeaponAmmoCount.set_text("x" + String(inventory[currentWeaponIndex].ammo.count))

	animationPlayer.play("fire-" + inventory[currentWeaponIndex].type)

func swapWeapons():
	var weaponTexture = load("res://assets/gui/equipped/equipped-" + inventory[currentWeaponIndex].type + ".png")
	equippedWeapon.set_texture(weaponTexture)
	sprite.set_frame(sprite.hframes * currentWeaponIndex)

	if currentWeaponIndex == 0:
		equippedWeaponAmmoCount.set_text("")
		return
	equippedWeaponAmmoCount.set_text("x" + String(inventory[currentWeaponIndex].ammo.count))

func takeDamage():
	.takeDamage()
	animationPlayer.play("hit")
	tween.interpolate_property(hpBar, "value", hp + 1, hp, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0)
	tween.start()

func _on_aliveTimer_timeout():
	if gameData.secondsAlive + 1 == 60:
		gameData.minutesAlive += 1.00
		gameData.secondsAlive = 0
	else:
		gameData.secondsAlive += 1.00
