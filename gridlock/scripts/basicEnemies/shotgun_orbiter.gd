extends CharacterBody2D
var speed: int = 200 # Speed of the enemy's movement
var orbit_radius: int = 450 # Desired distance from the player
var orbit_speed: int = 20 # How fast the enemy orbits
var player_position: Vector2
@export var bullet_node: PackedScene
var bullet_type: int = 0
var bulletspeed: int = 100
var target: Vector2
var move_speed: float = 0.8
var move_size: int = 500
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
		var perpendicular_direction = direction_to_player.rotated(PI / 2.0) # Rotate 90 degrees
		var orbital_velocity = perpendicular_direction * orbit_speed * orbit_radius

		velocity = radial_velocity + orbital_velocity
		move_and_slide()
