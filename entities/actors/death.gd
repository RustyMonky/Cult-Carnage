extends Sprite

# Generic death class for actors

onready var animationPlayer = $animationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("death")

func _on_animationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		self.queue_free()
