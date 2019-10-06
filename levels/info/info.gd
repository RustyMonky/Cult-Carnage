extends Control

func _ready():
	pass # Replace with function body.

func _on_play_pressed():
	sceneManager.goto_scene("res://levels/main/main.tscn")
