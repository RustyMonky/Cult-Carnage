extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_select"):
		sceneManager.goto_scene("res://levels/info/info.tscn")

func _on_play_pressed():
	sceneManager.goto_scene("res://levels/info/info.tscn")
