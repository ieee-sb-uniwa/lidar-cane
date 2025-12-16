extends RayCast3D
#how fast the raycast rotates
var rotation_speed = 120
@onready var rot_go
#a list for inserting the obstacles
var initial_rot
var mistake
#var obstacles_start = []
@onready var per: Node3D = $".."
@onready var col=30
@onready var timer: Timer = $Timer

func _ready():
	rot_go=0
	
func _process(delta):
	#rotates the raycast
	rotation_degrees.y += rotation_speed*delta
	rotation_degrees.y = fmod(rotation_degrees.y, 360)
	
	#calls the function that changes the rotation //I should change its name
	if int (rotation_degrees.y)>=280 and int (rotation_degrees.y)<=360:
		checker1()
		mistake=1
		
		
	if int (rotation_degrees.y)>=0 and int (rotation_degrees.y)<=80:
		checker2()
		
	
	if int (rotation_degrees.y)>=90 and int(rotation_degrees.y)<=100:
		per.rotation_degrees.y=rot_go
		print(rot_go)
	#creates an array with starting point of obstacles that are in front
	if is_colliding():
		col=1
	else:
		col=0



func checker1():
	if col == 0:
		rot_go=rotation_degrees.y



func checker2():
	if col == 0 and (360-rot_go>rotation_degrees.y) and mistake==1:
		rot_go=rotation_degrees.y
		mistake=0
