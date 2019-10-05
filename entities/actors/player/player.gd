extends "res://entities/actors/actor.gd"

onready var punchRaycast = $rayPunch

var currentWeaponIndex = 0
var inventory = [{'type': 'punch'}]

func _ready():
	speed = 64

func _input(event):
	if event.is_action_pressed("player_attack"):
		if currentWeaponIndex == 0: # Index 0 will always be the starting punch weapon
			if punchRaycast.is_colliding() && punchRaycast.get_collider().is_in_group("enemies"):
				punchRaycast.get_collider().takeDamage()
		else:
			fire()

	if event.is_action_pressed("player_scroll_left"):
		if currentWeaponIndex == 0:
			return
		currentWeaponIndex -= 1

	elif event.is_action_pressed("player_scroll_right"):
		if currentWeaponIndex == inventory.size() -1:
			return
		currentWeaponIndex += 1

func _physics_process(delta):
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("player_up"):
		direction.y = -1
		move(delta)
	elif Input.is_action_pressed("player_down"):
		direction.y = 1
		move(delta)
	else:
		direction.y = 0

	if Input.is_action_pressed("player_left"):
		direction.x = -1
		move(delta)
	elif Input.is_action_pressed("player_right"):
		direction.x = 1
		move(delta)
	else:
		direction.x = 0

# Logic to add ammo and weapons to the player's inventory
func addToInventory(weaponData):
	for weapon in inventory:
		if weapon.type == weaponData.type:
			weapon.ammo.count += weaponData.ammo.count
			return

	inventory.append(weaponData)

	# If currently punching, equip the gun
	if currentWeaponIndex == 0 && inventory.size() == 2:
		currentWeaponIndex = 1

# Eventually, this will need to support multiple projectile types
func fire():
	var projectile = load("res://entities/projectiles/projectile.tscn").instance()
	var projectileTexture = load("res://assets/projectiles/" + inventory[currentWeaponIndex].ammo.type + ".png")

	projectile.direction = self.position.direction_to(get_global_mouse_position())
	projectile.position = self.position
	projectile.get_node("sprite").set_texture(projectileTexture)
	projectile.collision_layer = 2 # This will allow it to collide with enemies!
	projectile.collision_mask = 1 # This will allow it to collide with enemies!

	get_parent().add_child(projectile)