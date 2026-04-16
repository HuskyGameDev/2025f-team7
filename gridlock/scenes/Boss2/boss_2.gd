extends Boss

const BOMB := preload("res://scenes/bomb.tscn")

const SCALE_OFFSCREEN := 7
const SCALE_STAGE_1 := 4
const SCALE_STAGE_2 := 3

const SHRINK_SPEED_STAGE_1 := 0.25
const SHRINK_SPEED_STAGE_2 := 0.1
const SHRINK_SPEED_STAGE_3 := 1.0
const SHRINK_ACCEL_STAGE_3 := 0.75

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var starting_pattern: int
@export var starting_movement: int
@export var bullet_node: PackedScene

@onready var centipede_spawner: Timer = $CentipedeSpawner
@onready var player_detection_shape := %PlayerDetectionShape
@onready var state_machine := $FiniteStateMachine

var bullet_type: int = 0
var speed: int = 100
var move_speed: float = 0.8
var move_size: int = 500
var radius: float = 480.0
var angle: float = 0.0
var stretch: float = 1.8
var pos: Vector2
var center: Vector2

# the boss will shrink towards this scale every frame
# (for the intro animation)
var target_scale := SCALE_STAGE_1

# the boss will shrink at this speed every frame
# (for the intro animation)
var shrink_speed := SHRINK_SPEED_STAGE_1

# describes which "stage" of the intro animation
# is playing
# (1 is the starting stage, 4 is the end)
@export var stage := 1:
	get(): return stage
	set(value):
		stage = value
		match stage:
			2:
				target_scale = SCALE_STAGE_2
				shrink_speed = SHRINK_SPEED_STAGE_2
			3:
				target_scale = 1
				shrink_speed = SHRINK_SPEED_STAGE_3
			4:
				GlobalSignals.boss_spawned.emit()
				state_machine.change_state("FollowLeaf")
				player_detection_shape.disabled = false


func _process(delta):
	super._process(delta)
	movement(delta)

#Function for boss movement
#func movement(delta):
	#angle += move_speed * delta
	#position.x = radius * cos(angle) * stretch
	#position.y = radius * sin(angle)
	#global_position =  pos + Vector2(position.x,position.y)

#Function for boss movement
func movement(delta):
	self.rotation += 0.5 * delta
	

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))
	
func _ready():
	super._ready()
	$AnimatedSprite2D.play("move")
	center = get_viewport().get_visible_rect().size * 0.5
	pos = global_position
	
	max_health = health
	
	modulate = Color.BLACK
	
	player_detection_shape.disabled = true
	match stage:
		1: scale = Vector2.ONE * SCALE_OFFSCREEN
		2: scale = Vector2.ONE * SCALE_STAGE_1
		3: scale = Vector2.ONE * SCALE_STAGE_2

func _physics_process(delta: float) -> void:
	scale = Vector2.ONE * move_toward(scale.x, target_scale, delta * shrink_speed)
	
	if stage == 3:
		modulate += Color.WHITE * delta
		shrink_speed += delta * SHRINK_ACCEL_STAGE_3
		if modulate.r > 1: modulate = Color.WHITE
		if scale.x == 1: stage = 4

func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	bullet.position = player_detection_shape.global_position
	bullet.direction = get_vector(angle)
	bullet.set_property(bullet_type)
	bullet.set_speed(speed)
	
	get_tree().current_scene.call_deferred("add_child", bullet)


func _on_speed_timeout() -> void:
	shoot(theta)

func _on_next_stage() -> void:
	stage += 1

func _on_death() -> void:
	var bomb := BOMB.instantiate()
	bomb.global_position = player_detection_shape.global_position
	add_sibling(bomb)
