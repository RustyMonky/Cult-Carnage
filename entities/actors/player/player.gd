extends "res://entities/actors/actor.gd"

onready var punchRaycast = $rayPunch

var inventory = []

func _ready():
	speed = 64

func _input(event):
	if event.is_action_pressed("player_attack"):
		if punchRaycast.is_colliding() && punchRaycast.get_collider().is_in_group("enemies"):
			punchRaycast.get_collider().takeDamage()

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