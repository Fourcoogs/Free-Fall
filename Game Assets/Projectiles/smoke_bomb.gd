extends Area2D
class_name SmokeBomb

@export var spinningSpeed: float = 30
@export var cloud: PackedScene
@export var speed: float = 100
@export var direction: Vector2

func _process(delta: float) -> void:
	rotation += spinningSpeed * delta
	pass

func Detonate(_body):
	if cloud != null:
		var cloudNode = cloud.instantiate()
		get_parent().add_child(cloudNode)
	queue_free()

func _physics_process(delta: float):
	position += direction * (speed * delta)
