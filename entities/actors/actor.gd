extends KinematicBody2D

onready var animationPlayer = $animationPlayer
onready var collider = $collider
onready var sprite = $sprite
onready var tween = $tween

# Stats
var hp = 3 # Just a default number to ensure takeDamage() works. It will be overriden by child classes.

# Movement
var direction = Vector2()
var speed = null

func _ready():
	set_physics_process(true)
	set_process_input(true)

func _input(event):
	pass

func _physics_process(delta):
	pass

func _on_animationPlayer_animation_finished(anim_name):
	animationPlayer.stop()

# Generic death logic for actors
func death(isPlayer = false):
	var bloodSplat = load("res://entities/actors/death.tscn").instance()
	bloodSplat.global_position = self.global_position
	get_parent().call_deferred("add_child", bloodSplat)

	if isPlayer:
		sceneManager.goto_scene("res://levels/gameover/gameover.tscn")
	else:
		self.queue_free()

# Generic projectile fire logic for actors
func fire():
	pass

# Generic movement logic for actors
func move(delta):
	var collision = self.move_and_collide(direction.normalized() * (speed * delta))

# Generic logic for actors to receive damage
func takeDamage():
	# Shake the screen -- assumes enemy is child of the level root node
	get_parent().screenShake(1, 2, 100)
	hp -= 1
	if (hp <= 0):
		death()