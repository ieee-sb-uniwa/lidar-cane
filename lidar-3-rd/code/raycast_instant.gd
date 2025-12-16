extends RayCast3D
var rotation_speed = 120
var obstacle = false
var collider = false
var original_rot = 0
var desired_rot = 0
@onready var servo = $".."

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	rotation_degrees.y += rotation_speed*delta
	rotation_degrees.y = fmod(rotation_degrees.y, 360)
	if int (rotation_degrees.y)<=20 or int (rotation_degrees.y)>=340:
		guidance(is_colliding())
		#returning(collider)
		
#check wether the ray is colliding or not. If it does, then rotate the player at the first available degree
#change the left vs right rotation issue
func guidance(colliding):
	if colliding:
		collider = true
	if collider and colliding:
		original_rot = servo.rotation_degrees.y
		if(rotation_degrees.y >=0 and rotation_degrees.y <=20):
			servo.rotation_degrees.y = rotation_degrees.y
		else:
			servo.rotation_degrees.y =  rotation_degrees.y - 360
		collider = false
#for returning back to og rotation		
func returning(colliding):
	if !colliding and servo.rotation.y != original_rot:
		servo.rotation_degrees.y = original_rot
