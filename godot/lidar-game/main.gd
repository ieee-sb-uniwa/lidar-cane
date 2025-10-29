extends Node3D

var server := TCPServer.new()
var client : StreamPeerTCP

const PORT = 65432
var movement = true
@onready var angle = get_node("Camera3D/RayCast3D")
var send = false
signal connected
var start = false

func _ready():
	var err = server.listen(PORT)
	if err != OK:
		print("Server failed to start: ", err)
	else:
		print("Server listening on port ", PORT)


func _process(_delta):
	# Check for new connections
	if server.is_connection_available():
		client = server.take_connection()
		print("Client connected!")
		emit_signal("connected")
		start = true
	# If connected, send data
	if client and client.get_status() == StreamPeerTCP.STATUS_CONNECTED and send == true:
		var message = str(angle.get_angles())
		client.put_data(message.to_utf8_buffer())
		

func _physics_process(delta):
	if(start == true):
		moving()
func _on_ray_cast_3d_stop_moving() -> void:
	movement = false
	send = true
	
func moving():
	if(movement):
		translate(Vector3(0,0,-.01))


func _on_ray_cast_3d_start_moving() -> void:
	movement = true
	send = false
