extends Node3D

@onready var box_scene = preload("res://box.tscn")

var move_speed = 30.0   # units per second
var direction = 1       # 1 = forward, -1 = backward
var axis = "x"          # current movement axis ("x" or "z")
var current_pos = 0
var parent_pos = 0
var box_instance: Node3D
@onready var parent = get_parent()

func _ready():
	current_pos = position.z
	parent_pos = parent.position.x
	

func _process(delta):
	if(get_child_count()<10):
		position.x = randi_range(-10,10)
		position.z = randi_range(current_pos-2, current_pos)
		current_pos = position.z
		spawn()
	else:
		if(parent_pos!=parent.position.z):
			for child in get_children():
				if(child.position.z>parent.position.z):
					remove_child(child)
			parent_pos = parent.position.z
#spawn crates
func spawn():
	box_instance = box_scene.instantiate()
	add_child(box_instance)
	box_instance.set_as_top_level(true)
	# direction in front of this node
	var forward = -transform.basis.z.normalized()
	
	# place the box in front of the player
	box_instance.global_position = global_position + forward
