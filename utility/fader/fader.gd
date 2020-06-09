extends ColorRect

onready var tween = $faderTween

var destinationScene

func _ready():
	self.modulate = Color(0, 0, 0, 0)

func fade(destination):
	destinationScene = destination
	tween.interpolate_property(self, "modulate", Color(0, 0, 0, 0), Color(0, 0, 0, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _on_faderTween_tween_completed(_object, _key):
	sceneManager.goto_scene(destinationScene)
