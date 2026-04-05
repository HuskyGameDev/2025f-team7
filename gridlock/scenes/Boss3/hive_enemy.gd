extends Enemy
#In spite of what would be best practice
#I do not know what any of these unlabeled variables do. Please don't ask. 
#I'll cry. 


@export var bullet_node: PackedScene

var speed: int = 200 # Speed of the enemy's movement
var player_position: Vector2
var bullet_type: int = 0
var move_speed: float = 0.1
var move_size: int = 100
var t: float = 0.0
var pos: Vector2 = Vector2.ZERO
var theta: float = PI
var time = 0
var phase2: bool = false
var startingSide: int


func _ready():
	super._ready()
	GlobalSignals.player_position.connect(_on_position_change)
	var timer = get_tree().get_first_node_in_group("Hive")
	timer.timeout.connect(_on_hive_timeout)

func _on_hive_timeout():
	if (phase2):
		shoot(PI)
	else:
		shoot(PI/-2*startingSide)

func _on_position_change(player_pos: Vector2):
	player_position = player_pos
	
func get_vector(angle):
	return Vector2(cos(angle),sin(angle))
	
func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	bullet.position = position
	bullet.direction = get_vector(angle)
	bullet.set_property(bullet_type)
	bullet.set_speed(speed)
	
	get_tree().current_scene.call_deferred("add_child", bullet)

func trackShoot(countRows, countCols, minVel, maxVel, angle):
	for n: int in countRows:
		speed = ((maxVel-minVel)/countRows)*n + minVel
		theta = Vector2(1,0).angle_to(target - position) - (angle/2)
		#shoot(theta)
		for m in countCols:
			shoot(theta)
		
	
func _physics_process(delta: float) -> void:
	time += delta
	if (!phase2):
		var y = sin(time)*startingSide*-1
		velocity = Vector2(100, 10*y)
		move_and_slide()
	else:
		var x = sin(time)
		var y = sin((time - 17.3)/5)
		velocity = Vector2(x*-40,y*-100*startingSide)
		move_and_slide()
		
	if (global_position.x >= 1700):
		phase2 = true

func _on_shoot_timeout() -> void:
	shoot(theta)
