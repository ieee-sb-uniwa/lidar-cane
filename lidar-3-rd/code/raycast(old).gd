extends RayCast3D
#how fast the raycast rotates
var rotation_speed = 360
var initial_rot
var mistake

@onready var per: Node3D = $".."
@onready var col=30
@onready var timer: Timer = $Timer
@onready var rot_go
#@onready var unrealistic_raycast: RayCast3D = $"../unrealistic_raycast"
signal col_check

func _ready():
	rot_go=0
	
func _process(delta):
	#rotates the raycast
	rotation_degrees.y += rotation_speed*delta
	rotation_degrees.y = fmod(rotation_degrees.y, 360)
	
	#calls the function that changes the rotation //I should change its name
	if int (rotation_degrees.y)>=270 and int (rotation_degrees.y)<=360:
		checker1()
		mistake=1
		
	if int (rotation_degrees.y)>=0 and int (rotation_degrees.y)<=90:
		checker2()
	
	
	if int (rotation_degrees.y)>=90 and int(rotation_degrees.y)<=92:
		per.rotation_degrees.y=rot_go
		print(rot_go)
		
	if int (rotation_degrees.y)>=98 and int(rotation_degrees.y)<=100:
		rot_go=0
	#creates an array with starting point of obstacles that are in front
	if is_colliding():
		col=1
	else:
		col=0




func checker1():
	#print("called checker1")
	if int (col) == 0:
		if (rotation_degrees.y>=0 and rotation_degrees.y<=5) or (rotation_degrees.y>=355 and rotation_degrees.y<=360):
			rot_go=rotation_degrees.y
		else:
			#unrealistic_raycast.rotation_degrees.y = rotation_degrees.y - 35
			#emit_signal("col_check")
			#if Global.is_col == false:
			rot_go=rotation_degrees.y - 45



func checker2():
	#print("called checker2")
	if (int (col) == 0 and (360-rot_go>rotation_degrees.y)) and mistake==1:
		if (rotation_degrees.y>=0 and rotation_degrees.y<=5) or (rotation_degrees.y>=355 and rotation_degrees.y<=360):
			rot_go=rotation_degrees.y
		else:
			#unrealistic_raycast.rotation_degrees.y = rotation_degrees.y + 35
			#emit_signal("col_check")
			#if Global.is_col == false:
			rot_go=rotation_degrees.y + 45
		mistake=0
