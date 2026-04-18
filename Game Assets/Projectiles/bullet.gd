extends Area2D

@export var speed: float = 500

func _physics_process(delta: float):
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta

func HitPlayer(body: Node2D):
	if body is Player:
		body.damage(1)
	queue_free()
