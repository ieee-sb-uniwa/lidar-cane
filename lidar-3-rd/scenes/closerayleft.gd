extends RayCast3D
@onready var person: Node3D = %Person



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		person.position.x+=0.1
