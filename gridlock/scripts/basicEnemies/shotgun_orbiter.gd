extends CharacterBody2D
#In spite of what would be best practice
#I do not know what any of these unlabeled variables do. Please don't ask. 
#I'll cry. 
var speed: int = 200 # Speed of the enemy's movement
var orbit_radius: int = 175 # Desired distance from the player
var orbit_speed: int = 5 # How fast the enemy orbits
var player_position: Vector2
@export var bullet_node: PackedScene
#related to health
@export var isMainBoss: bool = false
@export var health: float = 10

var beingHit: bool = false
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
		var perpendicular_direction = direction_to_player.rotated(PI / 2.0) # Rotate 90 degrees
		var orbital_velocity = perpendicular_direction * orbit_speed * orbit_radius

		velocity = radial_velocity + orbital_velocity
		move_and_slide()
		
func _process(delta):
	if (beingHit):
		health -= 10*delta
		if (health <= 0):
			die()
			
func die(): #This should run the second one, thus not ending the level. 
	if (isMainBoss):
		get_tree().call_group("game", "on_victory")
	queue_free()
	#For taking damage. 
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
func _on_player_detection_body_entered(body: Node2D) -> void:
	##print(body.name + " hit")
	if (body.name == "blade"):
		print("ouch - hit")
func _on_player_detection_body_exited(body: Node2D) -> void:
	##print(body.name + " out")
	if (body.name == "blade"):
		print("ouch - out")
func _on_shoot_timeout(angle) -> void:
	alpha = angle/5 #Count Columns
	for n: int in 1: #Count rows
		#maxvelocity and then min velocity
		speed = ((120-80)/10)*n + 80
		theta = Vector2(1,0).angle_to(target - position) - (angle/2)
		#shoot(theta)
		for m in 5:
			shoot(theta)
		
	
	
