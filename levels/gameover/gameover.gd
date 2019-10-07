extends Control

onready var mobsCount = $vbox/mobsKilledBox/count
onready var mobsBox = $vbox/mobsKilledBox
onready var returnLabel = $vbox/return
onready var timeBox = $vbox/timeAliveBox
onready var timeCount = $vbox/timeAliveBox/count
onready var tween = $tween

var statsShown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mobsCount.set_text(String(gameData.enemiesKilled))
	timeCount.set_text(String(gameData.minutesAlive) + ":" + String(gameData.secondsAlive))
	tween.interpolate_property(mobsBox, "rect_position", Vector2(-200, 34), Vector2(0, 34), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0)
	tween.interpolate_property(timeBox, "rect_position", Vector2(200, 54), Vector2(0, 54), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0)
	tween.start()

	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_select"):
		gameData.reset()
		sceneManager.goto_scene("res://levels/title/title.tscn")

func _on_tween_tween_completed(object, key):
	if statsShown:
		return
	tween.interpolate_property(returnLabel, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.5, Tween.TRANS_SINE, Tween.EASE_IN, 1)
	tween.start()
	statsShown = true
