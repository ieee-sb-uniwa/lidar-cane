extends RayCast3D
#how fast the raycast rotates
var rotation_speed = 240 # degrees per second
#a list for inserting the obstacles
var initial_rot
var obstacles = []


@onready var col=30
@onready var cam=$".."
@onready var timer: Timer = $Timer

func _ready():
	initial_rot=cam.rotation.y
	
func _process(delta):
	#rotates the raycast
	rotation_degrees.y += rotation_speed*delta
	rotation_degrees.y = fmod(rotation_degrees.y, 360)
	
	#resets the array when doing a rotation 
	if int (rotation_degrees.y)>=260 and int (rotation_degrees.y)<=270:
		print(obstacles)
		obstacles.clear()
	
	#calls the function that changes the rotation //I should change its name
	if int (rotation_degrees.y)>=90 and int (rotation_degrees.y)<=250:
		checker()
	
	#creates an array with starting point of obstacles that are in front
	if is_colliding():
		col=2
	elif (col==2): 
		if((rotation_degrees.y>=0 and rotation_degrees.y<=90) or (rotation_degrees.y>=270 and rotation_degrees.y<=360)):
			obstacles.append(int (rotation_degrees.y))
		col=1


func checker():
	print("called checker")
	var mi=obstacles.min()
	var ma=obstacles.max()
	if mi>(360-ma):
		cam.rotation_degrees.y = ma-20
	else:
		cam.rotation_degrees.y = mi-20
