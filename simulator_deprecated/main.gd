extends Node3D
#start a new tcp server
var server := TCPServer.new()
var client : StreamPeerTCP
const PORT = 65432
#boolean variable for the movement of the node
var movement = true
#get the raycast node
@onready var angle = get_node("Camera3D/RayCast3D")
#boolean for sending data to the raspi
var send = false
signal connected
#get the c# node
@onready var csharp = get_node("Node")
#set false for production
var start = true

func _ready():
	#only if the ip was sent to the raspberry
	if (csharp.ipSent == true):
		#listen to the port and check if it can start
		var err = server.listen(PORT)
		if err != OK:
			print("Server failed to start: ", err)
		else:
			print("Server listening on port ", PORT)


func _process(_delta):
	# Check for new connections
	if csharp.ipSent == true and server.is_connection_available():
		client = server.take_connection()
		print("Client connected!")
		emit_signal("connected")
		start = true
	# If connected, send data and send = true
	if client and client.get_status() == StreamPeerTCP.STATUS_CONNECTED and send == true:
		#send angles that the raycast gets
		var message = str(angle.get_angles())
		client.put_data(message.to_utf8_buffer())
		

func _physics_process(delta):
	if(start == true):
		moving()
		
func _on_ray_cast_3d_stop_moving() -> void:
	#when the raycast detects and obstacle, send the data to the raspberry pi and stop moving
	movement = false
	send = true
	
func moving():
	#simple movement script
	if(movement):
		translate(Vector3(0,0,-.005))


func _on_ray_cast_3d_start_moving() -> void:
	#stop sending data and start moving
	movement = true
	send = false
