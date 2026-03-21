extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var ran = get_viewport().get_mouse_position()
		var vec = Vector3.ZERO
		vec.x = ran.x
		vec.y = 0
		vec.z = ran.y
		navigation_agent_3d.set_target_position(vec)
		print(vec)
		print(ran)
		
func _physics_process(delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	var localcoords = destination - self.global_position
	var direction = localcoords.normalized()
	
	velocity = 1 * direction
	move_and_slide()
	
