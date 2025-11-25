extends RayCast3D
var sweep_speed = 2.0 
var max_angle= 90.0 
var time_passed = 0.0
func _process(delta):
	time_passed += delta * sweep_speed 
	rotation_degrees.x = sin(time_passed)
	

	
