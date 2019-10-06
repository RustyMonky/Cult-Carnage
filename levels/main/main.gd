extends Node2D

onready var camera = $camera
onready var tween = $tween

var currentShakePriority = 0

func _ready():
	pass # Replace with function body.

func moveCamera(vector):
	camera.set_offset(Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y)))

func screenShake(shakeDuration, power, priority):
	if priority > currentShakePriority:
		currentShakePriority = priority
		tween.interpolate_method(self, "moveCamera", Vector2(power, power), Vector2(0,0), shakeDuration, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
		tween.start()

func _on_tween_tween_completed(object, key):
	currentShakePriority = 0
