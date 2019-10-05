extends KinematicBody2D

var speed = null

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	pass

# Generic death logic for actors
func death():
	self.queue_free()

# Generic projectile fire logic for actors
func fire():
	pass

# Generic movement logic for actors
func move():
	pass
