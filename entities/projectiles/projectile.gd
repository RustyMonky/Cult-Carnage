extends Area2D

var direction = Vector2(0,0)
var speed = null

func _ready():
	speed = 64
	set_process(true)

func _process(delta):
	self.global_position += direction.normalized() * speed * delta
	
	if self.global_position.x < 0 || self.global_position.x > get_parent().get_node("viewport").size.x || self.global_position.y < 0 || self.global_position.y > get_parent().get_node("viewport").size.y:
		self.queue_free()

func _on_projectile_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage()
		self.queue_free()
