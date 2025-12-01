extends RayCast3D
#how fast the raycast rotates
var rotation_speed = 110 # degrees per second
#a list for inserting the obstacles
var initial_rot
@onready var col=1
@onready var cam=$"../Camera3D"
func _ready():
	initial_rot=rotation.y
	
func _process(delta):
	rotation_degrees.y += rotation_speed*delta
	rotation_degrees.y = fmod(rotation_degrees.y, 360)
	print(int (rotation_degrees.y))
	if is_colliding():
		col=2
	elif (col==2): 
		cam.rotation_degrees.y= rotation_degrees.y+20
		col=1
	
	
	
