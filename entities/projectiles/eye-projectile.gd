extends "res://entities/projectiles/projectile.gd"

func _ready():
	._ready()
	speed = 16

func _on_eyeprojectile_body_entered(body):
	body.takeDamage()
	self.queue_free()
