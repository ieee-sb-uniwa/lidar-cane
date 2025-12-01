extends RayCast3D
#how fast the raycast rotates
var rotation_speed = 40 # degrees per second
#direction of the raycast
var direction = 1 # 1 for increasing, -1 for decreasing
#a list for inserting the obstacles
var items = []
#get the camera node 
@onready var camera = get_parent()
@onready var ray = $'.'
#signals for when and obstacle is detected
signal stop_moving
signal start_moving
var prev_angle = 0
var i = 0
var angles_to_send = 0
var previous_angle = 0
const STEPS = 12
const START_DEGREE = -300
const END_DEGREE = -60
var angles_array = []
#set false for production
var start_game = true
var correction_angle
func _ready():
	ray.rotation_degrees.y = START_DEGREE
	prev_angle = START_DEGREE + STEPS
	correction_angle = prev_angle-1
	print(prev_angle)
func _process(delta):
	#if the game has start, rotate the raycast
	if start_game == true:
		ray.rotation_degrees.y = fmod(ray.rotation_degrees.y, 360)

		ray.rotation_degrees.y -= rotation_speed * delta
		#rot_func(60.0, delta, ray)
		#get the current angle
		var current_angle = int(rotation_degrees.y)

		#the code divides the space on 20 dividents. The array that will contain the 0 and 1 for the obstacles 
		#needs this in order to move the index
		#this line of code checks if the rotation has change
		print(current_angle)
		if(current_angle<=START_DEGREE or current_angle>=END_DEGREE):
			

			if((prev_angle-STEPS-1 <= current_angle and prev_angle-STEPS+1 >= current_angle)):
				print(i)
				#when the ray collides stop moving and enter 1 if the collider is box otherwise enter 0
				if ray.is_colliding():
					emit_signal("stop_moving")
					var collider = ray.get_collider()
					if collider.is_in_group("box"):
					
							
						items.append(1)
						#change the rotation of the servo (based on angles to send). If the obstacle is on the 
						#left, move the camera on the right
						#should probably make a smoother transition based on the index of the obstacle
						if(len(items)>1):
							if(items[i-1] == 0):
								if(i<STEPS/2):
									get_parent().get_parent().rotation_degrees.y -= STEPS
									angles_to_send = (rotation_degrees.y - STEPS)
									
								else:
									get_parent().get_parent().rotation_degrees.y += STEPS
									angles_to_send = (rotation_degrees.y + STEPS)
							
				else:
					items.append(0)
					emit_signal("start_moving")

				i += 1
				
				prev_angle = current_angle
				
				if((prev_angle <= -360+i and prev_angle+i >= -360-i)):
					prev_angle = STEPS
				if((prev_angle <= END_DEGREE+i and prev_angle+i >= END_DEGREE-i)):
					prev_angle = START_DEGREE + STEPS
				


			
		#clear the array and set the index to 0
			if(i>STEPS-1):
				items.clear()
				i = 0
			

#send only the angles that don't match the previous angles (in case te raycast gets stuck on an object)
func get_angles():
	if (previous_angle!=angles_to_send):
		previous_angle = angles_to_send
		return(int(angles_to_send))
	return("e")

#for starting the game
func _on_node_3d_connected() -> void:
	start_game = true
