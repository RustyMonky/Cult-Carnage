extends Area2D

onready var sprite = $sprite

var type
var weapons = [
	{
		'type': 'test-gun',
		'ammo': {
			'count': 10,
			'type': 'test-projectile'
		},
		'texture': 'res://assets/collectibles/weapons/test-gun.png'
	},
	{
		'type': 'eye-gun',
		'ammo': {
			'count': 5,
			'type': 'eye-projectile'
		},
		'texture': 'res://assets/collectibles/weapons/eye-gun.png'
	}
]

var weaponData

func _ready():
	for weapon in weapons:
		if weapon.type == type:
			weaponData = weapon
			var spriteTexture = load(weapon.texture)
			sprite.set_texture(spriteTexture)

func _on_weapon_body_entered(body):
	if body.is_in_group("player"):
		body.addToInventory(weaponData)
		self.queue_free()
