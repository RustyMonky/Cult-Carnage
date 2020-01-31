extends "res://levels/main/main.gd"

onready var prisonerSpeech = $ui/prisonerSpeech
onready var textTimer = $textTimer

var textIndex = 0
var textToSpeak = []

func _ready():
	prisonerSpeech.visible_characters = 0
	set_process_input(true)

func _input(event):
	if (event.is_action_pressed("player_attack")):
		if !textTimer.is_stopped():
			prisonerSpeech.visible_characters = 0
			textTimer.stop()
			continuePrisonerText()

func continuePrisonerText():
	if !textTimer.is_stopped():
		return

	if textIndex + 1 < textToSpeak.size():
		textIndex += 1
		prisonerSpeech.set_bbcode(textToSpeak[textIndex])
		textTimer.start()
	else:
		textToSpeak = []
		textIndex = 0
		prisonerSpeech.set_bbcode("")

# Timer for 0.5 second delay on beginning prisoner speech
func _on_delayTimer_timeout():
	# Add the prisoner's tutorial speech lines to the array and reset the index
	textToSpeak = [
		"So ... they nabbed [i]you[/i] too, huh?",
		"Those [b]damn[/b] cultists.",
		"I'm done for, but maybe I can help you escape!",
		"Move around with the W,A,S, and D keys.",
		"Aim with your mouse.",
		"Attack, click buttons, and cycle through text by left clicking.",
		"Now, get ready, I'm gonna give you an openin'.",
		"[shake rate=50 level=5][b]AT LAST, I'M FREEEEE![/b][/shake]"
	]
	prisonerSpeech.set_bbcode(textToSpeak[textIndex])
	textTimer.start()

# Timer for revealing speech characters
func _on_textTimer_timeout():
	if prisonerSpeech.visible_characters == textToSpeak[textIndex].length():
		textTimer.stop()
	else:
		prisonerSpeech.visible_characters += 1
