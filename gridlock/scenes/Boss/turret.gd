extends Node2D

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var starting_pattern: int
@export var starting_movement: int
@export var health: float
@export var bullet_node: PackedScene

var bullet_type: int = 0
var speed: int = 100
var target: Vector2
var move_speed: float = 0.8
var move_size: int = 500
var t: float = 0.0
var pos: Vector2 = Vector2.ZERO
var beingHit: bool = false
var max_health: float

func _on_boss_died() -> void:
	queue_free()

func _process(delta):
	if beingHit:
		health -= 10 * delta
		if health <= 0: queue_free()

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
		for m in countCols:
			shoot(theta)
		
	
func _ready():
	GlobalSignals.player_position.connect(_track)
	GlobalSignals.boss_died.connect(_on_boss_died)
	pos = global_position
	
	max_health = health

func _track(location: Vector2):
	target = location

func _on_player_detection_area_entered(area: Area2D) -> void:
	if area.name == "BladeArea2D":
		beingHit = true


func _on_player_detection_area_exited(area: Area2D) -> void:
	if area.name == "BladeArea2D":
		beingHit = false
