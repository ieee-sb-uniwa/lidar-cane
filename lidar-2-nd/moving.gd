extends Node3D
@onready var camera = get_node("Camera3D")
var can_rotate = true
var rot = 0
var state
enum  {MOVE_FORWARD, ROTATE}
func _ready() -> void:
	Engine.time_scale = 0.1
func _physics_process(delta: float) -> void:
	translate(Vector3(0,0,-0.1)*delta*60)
	if can_rotate:		
		pass
		
	if !can_rotate:
		var current_rot = global_rotation.y
		translate(Vector3(0,0,-.1)*delta*60)
		rotation.y = lerp(current_rot, rot, 0.1)
		translate(Vector3(0,0,-.1)*delta*60)
		can_rotate = true
		
func rand_rot():
	state = ROTATE
	rot = global_rotation.y
	print("initial rotation: ", rot)
	rotation.y = randf_range(-10.0,10.0)
	print("changed rotation: ", global_rotation.y)	
	can_rotate = false
	
	

	
	
