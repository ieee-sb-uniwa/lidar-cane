extends Node3D
@onready var camera = get_node("Camera3D")

var rot = 0.0
var timer = 0
var end_timer = 1.0
var SPEED = 6.0
#states
var state = ROTATE
enum  {MOVE_FORWARD, ROTATE}

func _ready() -> void:
	#initialise the rotation parameter
	rot = global_rotation.y

func _physics_process(delta: float) -> void:
	#move the timer
	timer+=delta
	#change behaviour based on state
	match state:
		ROTATE:
			#in rotation do nothing for a time and then move
			if (timer >= end_timer):
				start_move()
				
		MOVE_FORWARD:
			#when moving forward, move for a time. In the last moment rotate on the default rotation, then start the random rotation
			translate(Vector3(0, 0, -0.1) * SPEED * delta) 
			if(timer >= end_timer-.1):
				rotation.y = rot
			if (timer >= end_timer):
				start_rot()

#these funcitons happen only once per iteration
func start_rot():
	#change the state and zero the timer
	state = ROTATE
	timer = 0
	#get the default rotation and then rotate randomly
	rot = global_rotation.y
	print("initial rotation: ", rot)
	rotation.y = randf_range(deg_to_rad(-45.0), deg_to_rad(45.0))
	print("changed rotation: ", global_rotation.y)
	
	

func start_move():
	#just change the state and zero the timer
	state = MOVE_FORWARD
	timer = 0
	
	
	
	
