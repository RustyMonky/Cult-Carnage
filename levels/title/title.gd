extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_select"):
		fade()

func _on_play_pressed():
	fade()

func fade():
	var fader = load("res://utility/fader/fader.tscn").instance()
	self.add_child(fader)
	fader.fade("res://levels/tutorial/tutorial.tscn")
