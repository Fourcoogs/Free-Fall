extends Area2D
class_name Smoke

func SubjectEntered(body: Node2D):
	pass


func Dissipate():
	modulate.a -= 1
	if (modulate.a >= 0):
		queue_free()
