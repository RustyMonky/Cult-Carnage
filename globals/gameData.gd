extends Node

var enemies = [{
	"name": "enemey",
	"path": "res://entities/actors/enemies/enemy.tscn"
}, {
	"name": "eye",
	"path": "res://entities/actors/enemies/eye/eye.tscn"
}]
var enemiesKilled = 0
var minutesAlive = 0.00
var playerAlive = true
var secondsAlive = 0.00

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset():
	enemiesKilled = 0
	minutesAlive = 0.00
	playerAlive = true
	secondsAlive = 0.00