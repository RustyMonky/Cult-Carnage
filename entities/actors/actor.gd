extends KinematicBody2D

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
	pass
