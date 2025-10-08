extends CharacterBody2D

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0

@export var bullet_node: PackedScene
var bullet_type: int = 0
var speed: int = 100
var target: Vector2
var move_speed: int = 1
var move_size: int = 500
var t: float = 0.0
var pos: Vector2 = Vector2.ZERO

func _process(delta):
	movement(delta)

#Function for boss movement
func movement(delta):
	t += delta * move_speed
	var x = move_size * sin(t)
	var y = move_size * sin(t) * cos(t)
	global_position = pos + Vector2(x,y)
	

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))

func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	bullet.position = global_position
	bullet.direction = get_vector(angle)
	bullet.set_property(bullet_type)
	bullet.set_speed(speed)
	
	get_tree().current_scene.call_deferred("add_child", bullet)

func _on_speed_timeout():
	shoot(theta)

func burst(countCircle, countOut, minVel, maxVel):
	alpha = 2*PI/countCircle
	for n in countOut:
		speed = ((maxVel-minVel)/countOut)*n + minVel
		for m in countCircle:
			shoot(theta)

func trackShoot(countRows, countCols, minVel, maxVel, angle):
	alpha = angle/countCols
	for n: int in countRows:
		speed = ((maxVel-minVel)/countRows)*n + minVel
		theta = Vector2(1,0).angle_to(target - position) - (angle/2)
		#shoot(theta)
		for m in countCols:
			shoot(theta)
		
	
func _ready():
	GlobalSignals.connect("player_position", Callable(self, "_track"))
	pos = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 4)

func _track(location: Vector2):
	target = location
