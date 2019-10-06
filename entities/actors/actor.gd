extends KinematicBody2D

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

# Generic death logic for actors
func death():
	self.queue_free()

# Generic projectile fire logic for actors
func fire():
	pass

# Generic movement logic for actors
func move(delta):
	self.move_and_collide(direction.normalized() * (speed * delta))

# Generic logic for actors to receive damage
func takeDamage():
	# Shake the screen -- assumes enemy is child of the level root node
	get_parent().screenShake(1, 2, 100)
	hp -= 1
	if (hp <= 0):
		death()