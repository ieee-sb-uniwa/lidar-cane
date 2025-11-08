import socket
import serial
ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=5)
print("Waiting for IP...")
while True:
    if ser.in_waiting > 0:
        ip = ser.readline().decode('utf-8').strip()
        HOST = ip
        break
print(HOST)
PORT = 65432
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((HOST, PORT))
try:
	while True:
		data = client_socket.recv(1024).decode()
		print(data)
except KeyboardInterrupt:
	print("shutdown")
finally:
	client_socket.close()




# Adjust the port name based on your Pi’s device
# e.g. /dev/ttyUSB0 or /dev/ttyACM0


