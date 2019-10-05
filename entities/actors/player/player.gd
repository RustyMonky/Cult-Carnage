extends "res://entities/actors/actor.gd"

onready var punchRaycast = $rayPunch

func _ready():
	speed = 16

func _input(event):
	if event.is_action_pressed("player_attack"):
		print("Attack!")
		# Eventually, replace the above with:
		# - turning on the punching raycast
		# - detecting enemy collision
		# - if enemy detected, hit 'em
		# - re-disable raycast

func _physics_process(delta):
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("player_up"):
		direction.y = -1
		move(delta)
	elif Input.is_action_pressed("player_down"):
		direction.y = 1
		move(delta)
	elif Input.is_action_pressed("player_left"):
		direction.x = -1
		move(delta)
	elif Input.is_action_pressed("player_right"):
		direction.x = 1
		move(delta)


func move(delta):
	self.move_and_collide(direction * speed * delta)