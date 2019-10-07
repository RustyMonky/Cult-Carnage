extends Node

var enemies = [{
	"name": "enemey",
	"path": "res://entities/actors/enemies/enemy.tscn"
}, {
	"name": "eye",
	"path": "res://entities/actors/enemies/eye/eye.tscn"
}]
var enemiesKilled = 0
var timeAlive = 0.00
var playerAlive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
