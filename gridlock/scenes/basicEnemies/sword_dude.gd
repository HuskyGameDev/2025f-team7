extends CharacterBody2D
#In spite of what would be best practice
#I do not know what any of these unlabeled variables do. Please don't ask. 
#I'll cry. 
var speed: int = 75 # Speed of the enemy's movement
var orbit_radius: int = 0 # Desired distance from the player
var orbit_speed: int = 0 # How fast the enemy orbits
var player_position: Vector2
@export var bullet_node: PackedScene
var bullet_type: int = 0
var bulletspeed: int = 100
var target: Vector2
var move_speed: float = 0.2
var move_size: int = 200
var t: float = 0.0
var pos: Vector2 = Vector2.ZERO
var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var starting_pattern: int
@export var starting_movement: int
func _ready():
	GlobalSignals.player_position.connect(_on_position_change)

func _on_position_change(player_pos: Vector2):
	player_position = player_pos
	
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

func trackShoot(countRows, countCols, minVel, maxVel, angle):
	alpha = angle/countCols
	for n: int in countRows:
		speed = ((maxVel-minVel)/countRows)*n + minVel
		theta = Vector2(1,0).angle_to(target - position) - (angle/2)
		#shoot(theta)
		for m in countCols:
			shoot(theta)
		
	
func _physics_process(delta: float) -> void:
	if player_position:
		var direction_to_player = (player_position - global_position).normalized()
		var distance_to_player = global_position.distance_to(player_position)

		# Movement towards/away from player to maintain orbit radius
		var radial_velocity = Vector2.ZERO
		if distance_to_player > orbit_radius:
			radial_velocity = direction_to_player * speed
		elif distance_to_player < orbit_radius:
			radial_velocity = -direction_to_player * speed

		# Orbital movement (perpendicular to direction to player)
		#var perpendicular_direction = direction_to_player.rotated(PI / 2.0) # Rotate 90 degrees
		#var orbital_velocity = perpendicular_direction * orbit_speed * orbit_radius

		velocity = radial_velocity
		move_and_slide()


	
	
