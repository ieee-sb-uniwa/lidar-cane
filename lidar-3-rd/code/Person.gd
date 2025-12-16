extends Node3D

var velocity = 0.01

# Makes the person move forward based on their rotation
func _physics_process(delta):
	position += global_transform.basis * Vector3(0,0,-velocity) 
