extends Node3D

@onready var box_scene = preload("res://box.tscn")
#move speed of the spawner
var move_speed = 30.0  
#direction of the spawner
var direction = 1      
var axis = "x"         
#current position of the spawner
var current_pos = 0
#current position of the root node 
var parent_pos = 0
var box_instance: Node3D
@onready var parent = get_parent()
#gets the z axis position of the box and the x axis postiion of the spawner
func _ready():
	current_pos = position.z
	parent_pos = parent.position.x
	
#if there are less tan 10 boxes
func _process(delta):
	if(get_child_count()<10):
		#move the spawner on a random x direction and a random z direction
		position.x = randi_range(-10,10)
		position.z = randi_range(current_pos-2, current_pos)
		#set the current z position of the spawner
		current_pos = position.z
		spawn()
	else:
		#if there are more than 10 childer delete any children that are behind the player (parent)
		if(parent_pos!=parent.position.z):
			for child in get_children():
				if(child.position.z>parent.position.z):
					remove_child(child)
			parent_pos = parent.position.z
#spawn crates
func spawn():
	#instantiate a box scene
	box_instance = box_scene.instantiate()
	add_child(box_instance)
	#unlink it from the movements of the spawner
	box_instance.set_as_top_level(true)
	# direction in front of this node
	var forward = -transform.basis.z.normalized()
	# place the box in front of the player
	box_instance.global_position = global_position + forward
