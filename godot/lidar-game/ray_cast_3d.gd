extends RayCast3D

var rotation_speed = 90.0 # degrees per second
var direction = 1 # 1 for increasing, -1 for decreasing
var items = []
@onready var camera = get_parent()
@onready var ray = $'.'
signal stop_moving
signal start_moving
var prev_angle = 0
var i = 0
var angles_to_send = 0
var previous_angle = 0
var start_game = false
func _ready():
	rotation_degrees.y += 60
func _process(delta):
	if start_game == true:
		rot_func(60.0, delta, ray)
		var deg = int(rotation_degrees.y)
		var current_angle = rotation_degrees.y
		if int(current_angle / 6) != int(prev_angle / 6):
			i += 1
				
		
		if ray.is_colliding():
			emit_signal("stop_moving")
			var collider = ray.get_collider()
			if collider.is_in_group("box"):
			#	print("Hit object:", collider)
				if int(current_angle / 6) != int(prev_angle / 6):
					items.append(1)
				if(len(items)>1):
					
					if(items[i-1] == 0):
						if(i<10):
							get_parent().get_parent().rotation_degrees.y += 6
							angles_to_send = (rotation_degrees.y + 6)
							
						else:
							get_parent().get_parent().rotation_degrees.y -= 6
							angles_to_send = (rotation_degrees.y - 6)
					#print(int(angles_to_send))
				
					
		else:
				if int(current_angle / 6) != int(prev_angle / 6):
					items.append(0)
					emit_signal("start_moving")
					
		if(i>19):
			items.clear()
			i = 0
		prev_angle = current_angle
		#else:
			#get_parent().get_parent().position.x = 10
			


func rot_func(limit, delta, target):
	target.rotation_degrees.y += rotation_speed * delta * direction
	# When reaching limits, flip direction
	if target.rotation_degrees.y >= limit:
		target.rotation_degrees.y = limit
		direction = -1
	elif target.rotation_degrees.y <= -limit:
		target.rotation_degrees.y = -limit
		direction = 1
func get_angles():
	if (previous_angle!=angles_to_send):
		previous_angle = angles_to_send
		return(int(angles_to_send))
	return("e")


func _on_node_3d_connected() -> void:
	start_game = true
