extends CharacterBody2D

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var starting_pattern: int
@export var starting_movement: int
@export var bullet_node: PackedScene

var bullet_type: int = 0
var speed: int = 100
var target: Vector2
var move_speed: float = 0.8
var move_size: int = 500
var radius: float = 480.0
var angle: float = 0.0
var stretch: float = 1.8
var pos: Vector2
var center: Vector2

func _process(delta):
	movement(delta)

#Function for boss movement
func movement(delta):
	angle += move_speed * delta
	position.x = radius * cos(angle) * stretch
	position.y = radius * sin(angle)
	global_position =  pos + Vector2(position.x,position.y)
	

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))
	
func _ready():
	center = get_viewport().get_visible_rect().size * 0.5
	pos = global_position
	GlobalSignals.connect("player_position", Callable(self, "_track"))
	

func _track(location: Vector2):
	target = location
