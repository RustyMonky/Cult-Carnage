extends Area2D

var ammo = {
	'count': 10,
	'type': 'test-projectile'
}

var weaponData = {
	'type': 'test-gun',
	'ammo': ammo
}

func _ready():
	pass

func _on_weapon_body_entered(body):
	if body.is_in_group("player"):
		body.addToInventory(weaponData)
		self.queue_free()
