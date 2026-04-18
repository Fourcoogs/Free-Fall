extends Area2D
class_name Smoke

var toBeCleared = false

var smokedObjects: Array

func SubjectEntered(body: Node2D):
	if (body is Player or Enemy) && !toBeCleared:
		body.smoked = true
		smokedObjects.append(body)
	pass

func SubjectExited(body: Node2D):
	if body is Player or Enemy:
		body.smoked = false
		smokedObjects.append(body)

func Dissipate():
	modulate.a -= 0.01
	if (modulate.a <= 0):
		queue_free()
		ClearSmoke()
		toBeCleared = true
		
func ClearSmoke():
	for i in smokedObjects:
		i.smoked = false
