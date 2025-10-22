extends Node3D

var server := TCPServer.new()
var client : StreamPeerTCP

const PORT = 65432

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

	# If connected, send data
	if client and client.is_connected_to_host():
		var message = "Hello from Godot!"
		client.put_utf8_string(message)
		client.put_u8(10)  # newline or delimiter
		client.flush()
		print(message)
