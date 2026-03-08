extends RayCast3D

#how fast the raycast rotates
var rotation_speed = 240
var initial_rot
var mistake #makes sure that checker 2 stops wasting resources after it finds an angle
var mistake2=true
var origin
var collision_point #coordinates of collision point
var distance = 20 #distance between collision point and camera
var dead_point = 0 
var dead_end_mode = false
var can_go = false
@onready var per = %Person
@onready var col=30
@onready var rot_go #saves the angle the camera should be sent in every rotation
@onready var ray = $"."

func _ready():
	rot_go=0

func _process(delta):
	#rotates the raycast
	rotation_degrees.y += rotation_speed*delta
	rotation_degrees.y = fmod(rotation_degrees.y, 360)
	
	if mistake2==true:
		dead_end_mode=false
		
	#dynamically changes the speed of the raycast (will be removed in the lidar)
	if (rotation_degrees.y>-100 and rotation_degrees.y<0) or (rotation_degrees.y>0 and rotation_degrees.y<100):
		rotation_speed = 240
	else:
		rotation_speed = 2000
	
	#checkes the right side for an appropriate angle
	if int (rotation_degrees.y)>=-90 and int (rotation_degrees.y)<0:
		rightsiderot()
		mistake=1
	
	#checks the left side for a better angle
	if int (rotation_degrees.y)>=0 and int (rotation_degrees.y)<=90:
		leftsiderot()
	
	#changes the direction of the camera
	if int (rotation_degrees.y)>=90 and int(rotation_degrees.y)<92:
		per.rotation_degrees.y=rot_go

	#resetting rot_go
	if int (rotation_degrees.y)>=101 and int(rotation_degrees.y)<=180:
		rot_go=0
	
	#getting th point where raycast hit object
	if is_colliding():
		origin = global_transform.origin
		collision_point = ray.get_collision_point()
		distance = origin.distance_to(collision_point)
	else: 
		distance = 20

func rightsiderot():
	#finds the side closest freepoint that continues forward on the right side
	if distance > 1.2:
		if (int(rotation_degrees.y)>=-10 and int(rotation_degrees.y)<=0):
			rot_go = 0
		else:
			rot_go = rotation_degrees.y - 45
		can_go = true

func leftsiderot():
	#checks if there is a better angle that continues forward in the left side
	if distance > 1.2 and (abs(int(rot_go))>int(rotation_degrees.y)) and mistake==1:
		if (int(rotation_degrees.y)>=0 and int(rotation_degrees.y)<=10):
			rot_go = 0
		else:
			rot_go = rotation_degrees.y + 45
		mistake=0
		can_go = true

#func dead_end_check():
#	if abs(per.rotation_degrees.y - rot_go)>=180:
#		dead_point += 1
#		
#	if abs(per.rotation_degrees.y - rot_go)<10:
#		dead_point = 0
#		dead_end_mode = false
#		
#	if dead_point == 2:
#		print("dead_point_found")
#		dead_end_mode = true

#func dead_end_resolve():
#	if rotation_degrees.y== per.rotation_degrees.y and distance<1.2:
#		per.rotation_degrees ==
