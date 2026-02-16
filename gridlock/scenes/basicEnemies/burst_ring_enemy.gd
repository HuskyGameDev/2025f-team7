extends CharacterBody2D

# this "enemy" is used exclusively for patterns with boss 2 and cannot be harmed

@export var bullet_node: PackedScene
@export var starting_pattern: int
@export_range(0,2*PI) var alpha: float = 0.0
var bullet_type: int = 0
var speed: int = 100
var theta: float = 0.0

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))

func shoot(angle, posX, posY):
	var bullet = bullet_node.instantiate()
	
	bullet.position = position + Vector2(posX, posY)
	bullet.direction = get_vector(angle)
	bullet.set_property(bullet_type)
	bullet.set_speed(speed)
	bullet.set_speed_change(2)
	
	get_tree().current_scene.call_deferred("add_child", bullet)

func burst(countCircle, countOut, minVel, maxVel, posX, posY):
	alpha = 2*PI/countCircle
	for n in countOut:
		speed = ((maxVel-minVel)/countOut)*n + minVel
		for m in countCircle:
			shoot(theta, posX, posY)
