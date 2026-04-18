extends Area2D
class_name Knife

@export var speed: float = 1000

func _physics_process(delta: float):
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta

func HitEnemy(body: Node2D):
	if body is Enemy:
		body.KillEnemy()
	queue_free()
