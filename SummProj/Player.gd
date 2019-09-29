extends KinematicBody
 
var path = []
var path_ind = 0
export var move_speed = 8
onready var nav = get_parent()

var camBase = load("res://CameraBase.gd").new()

var location = Vector3(0,0,0)
var velocity = Vector3(0,0,0)
var acceleration = Vector3(0,0,0)

export var maxspeed = 4
export var maxforce = .1

func _process(delta):
	pass

func _physics_process(delta):	
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
 
func move_to(target_pos):
	# seek(target_pos)
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

func update():
	velocity += acceleration
	velocity = limit(maxspeed, velocity)
	location += velocity
	acceleration *= 0

func applyForce(force):
	acceleration += force

func seek(target):
	var desired = Vector3(0,0,0)
	desired = target - location
	desired = desired.normalized()
	desired *= maxspeed
	var steer = Vector3(0,0,0)
	steer = desired - velocity
	steer = limit(maxforce, steer)
	applyForce(steer)

func limit(value, vec):
	var length = vec.x*vec.x + vec.y*vec.y + vec.z*vec.z
	
	if (length*length > value*value) and (length*length) > 0:
		var ratio = value/(sqrt(length))
		vec.x *= ratio
		vec.y *= ratio
		vec.z *= ratio
	return Vector3(vec.x, vec.y, vec.z)

func _on_IceFloor_body_entered(body):
	if body.name == "Player":
		move_speed = 5

func _on_IceFloor_body_exited(body):
	if body.name == "Player":
		move_speed = 8

