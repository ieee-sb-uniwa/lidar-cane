extends RayCast3D
@onready var person: Node3D = %Person

func _process(delta):
	if is_colliding():
		person.position.z+=1
