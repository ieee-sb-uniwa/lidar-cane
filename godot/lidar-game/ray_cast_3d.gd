extends RayCast3D

var rotation_speed = 90.0 # degrees per second
var direction = 1 # 1 for increasing, -1 for decreasing

func _process(delta):
	rotation_degrees.y += rotation_speed * delta * direction
	
	# When reaching limits, flip direction
	if rotation_degrees.y >= 60.0:
		rotation_degrees.y = 60.0
		direction = -1
	elif rotation_degrees.y <= -60.0:
		rotation_degrees.y = -60.0
		direction = 1




	
