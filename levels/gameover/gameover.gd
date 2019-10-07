extends Control

onready var mobsCount = $vbox/mobsKilledBox/count
onready var mobsBox = $vbox/mobsKilledBox
onready var timeBox = $vbox/timeAliveBox
onready var timeCount = $vbox/timeAliveBox/count
onready var tween = $tween

# Called when the node enters the scene tree for the first time.
func _ready():
	mobsCount.set_text(String(gameData.enemiesKilled))
	timeCount.set_text(String(gameData.minutesAlive) + ":" + String(gameData.secondsAlive))
	tween.interpolate_property(mobsBox, "rect_position", Vector2(-200, 34), Vector2(0, 34), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0)
	tween.interpolate_property(timeBox, "rect_position", Vector2(200, 54), Vector2(0, 54), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0)
	tween.start()
