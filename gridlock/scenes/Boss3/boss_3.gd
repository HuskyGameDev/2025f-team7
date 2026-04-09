extends Boss

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var starting_pattern: int
@export var starting_movement: int
@export var bullet_node: PackedScene

var bullet_type: int = 0
var speed: int = 200
var move_speed: float = 0.8
var move_size: int = 500
var radius: float = 480.0
var angle: float = 0.0
var stretch: float = 1.8
var pos: Vector2
var center: Vector2
var beingHit: bool = false
var time: float = 0
var tracking: bool = false

func _physics_process(delta: float):
	time = time + delta
	movement(time)

#Function for boss movement
#func movement(delta):
	#angle += move_speed * delta
	#position.x = radius * cos(angle) * stretch
	#position.y = radius * sin(angle)
	#global_position =  pos + Vector2(position.x,position.y)

#Function for boss movement
func movement(delta):
	global_position = Vector2(sin(delta)*30+60, cos(delta/2)*120+520)
	

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))
	
func _ready():
	GlobalSignals.boss_spawned.emit()
	super._ready()
	pos = global_position
	
	max_health = health

func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	bullet.position = $PlayerDetection/CollisionShape2D.global_position
	bullet.direction = get_vector(angle)
	bullet.set_property(bullet_type)
	bullet.set_speed(speed)
	
	get_tree().current_scene.call_deferred("add_child", bullet)

func trackshoot():
	var bullet = bullet_node.instantiate()
	
	bullet.position = $PlayerDetection/CollisionShape2D.global_position
	var ang = Vector2(1,0).angle_to(target - position)
	bullet.direction = Vector2(cos(ang),sin(ang))
	bullet.set_property(bullet_type)
	bullet.set_speed(speed)
	
	get_tree().current_scene.call_deferred("add_child", bullet)


func _on_speed_timeout() -> void:
	if (tracking):
		trackshoot()
	else:
		shoot(theta)
