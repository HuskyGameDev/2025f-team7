extends CharacterBody2D

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var starting_pattern: int
@export var starting_movement: int
@export var health: float
@export var bullet_node: PackedScene
@export var isMainBoss: bool
var bullet_type: int = 0
var speed: int = 100
var target: Vector2
var move_speed: float = 0.8
var move_size: int = 500
var t: float = 0.0
var pos: Vector2 = Vector2.ZERO
var beingHit: bool = false

func _process(delta):
	if (beingHit):
		health -= 10*delta
		if (health <= 0):
			die()

func die():
	if (isMainBoss):
		get_tree().call_group("game", "on_victory")
	queue_free()
#Function for boss movement
#func movement(delta):
#	t += delta * move_speed
#	var x = move_size * sin(t)
#	var y = move_size * sin(t) * cos(t)
#	global_position = pos + Vector2(x,y)
	

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
	$AnimatedSprite2D.play("move")
	GlobalSignals.connect("player_position", Callable(self, "_track"))
	pos = global_position

func _track(location: Vector2):
	target = location
	


## IGNORE THE BODY_ENTERED
func _on_player_detection_body_entered(body: Node2D) -> void:
	##print(body.name + " hit")
	if (body.name == "blade"):
		print("ouch - hit")


func _on_player_detection_body_exited(body: Node2D) -> void:
	##print(body.name + " out")
	if (body.name == "blade"):
		print("ouch - out")
		


## Functions to track the blade collision
func _on_player_detection_area_entered(area: Area2D) -> void:
	##print(area.name + " in")
	if (area.name == "BladeArea2D"):
		print("ouch - in")
		beingHit = true


func _on_player_detection_area_exited(area: Area2D) -> void:
	##print(area.name + " out")
	if (area.name == "BladeArea2D"):
		print("ouch - out")
		beingHit = false
