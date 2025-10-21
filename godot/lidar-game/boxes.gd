extends Node3D

@onready var box_scene = preload("res://box.tscn")

var move_speed = 30.0   # units per second
var direction = 1       # 1 = forward, -1 = backward
var axis = "x"          # current movement axis ("x" or "z")

var box_instance: Node3D

func _ready():
	box_instance = box_scene.instantiate()
	add_child(box_instance)
	box_instance.set_as_top_level(true)
	

func _process(delta):
	if axis == "x":
		position.x += move_speed * delta * direction
		if position.x >= 60:
			position.x = 60
			direction = -1
		elif position.x <= -60:
			position.x = -60
			direction = 1
			axis = "z"  # switch axis when done
	elif axis == "z":
		position.z += move_speed * delta * direction
		if position.z >= 60:
			position.z = 60
			direction = -1
		elif position.z <= -60:
			position.z = -60
			direction = 1
			axis = "x"  # switch back to x axis
	box_instance = box_scene.instantiate()
	add_child(box_instance)
	box_instance.set_as_top_level(true)
