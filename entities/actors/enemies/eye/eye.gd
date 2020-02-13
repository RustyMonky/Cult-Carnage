extends "res://entities/actors/enemies/enemy.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	hp = 3
	speed = 24
	usedProjectile = "res://entities/projectiles/eye-projectile.tscn"
	droppedWeapon = "res://entities/collectibles/weapons/weapon.tscn"
	droppedWeaponType = 'eye-gun'

func death():
	droppedWeaponType = 'eye-gun'
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
	animationPlayer.play("eye-fire")

func _on_projectileTimer_timeout():
	fire()

func _on_animationPlayer_animation_finished(_anim_name):
	animationPlayer.stop()
	sprite.set_frame(0)
