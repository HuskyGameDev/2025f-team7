extends CharacterBody2D

signal player_position(location: Vector2)


var SPEED = 300.0
var SHIFTSPEED = 450
var CTRLSPEED = 150
var BOMBAVAIL = true; 
const SPEED_STANDARD = 150
@onready var debug = $debug
@onready var progress_bar = $ProgressBar

@onready var sprite = $Sprite2D

@export var health_sprites: Array[Texture2D] = []

var health := 10:
	set(value):
		value = clamp(value, 0, 10)
		if value != health:
			health = value
			progress_bar.value = value
			_update_sprite()
		if value == 0:
			get_tree().change_scene_to_file("res://scenes/Title/Title.tscn")
func _ready():
	emit_signal("player_position", global_position)

func _physics_process(delta: float):
	var currentSpeed = SPEED
	if Input.is_action_pressed("FastWalk"):
		currentSpeed = SHIFTSPEED
	if Input.is_action_pressed("SlowWalk"):
		currentSpeed = CTRLSPEED
	if Input.is_action_just_pressed("UseBomb"):
		if BOMBAVAIL == true:
			get_tree().call_group("Bullet", "blow_up")
			BOMBAVAIL = false
			GlobalSignals.emit_signal("bomb_used")
	
	
	velocity = Input.get_vector("MainPlayerMoveLeft","MainPlayerMoveRight","MainPlayerMoveUp","MainPlayerMoveDown") * currentSpeed
	
	move_and_slide()
	GlobalSignals.emit_signal("player_position", position)

func set_status(bullet_type):
	match bullet_type:
		0:
			fire()
		1:
			poison()
		2:
			slow()
		3:
			stun()

func fire():
	debug.text = "fire"
	health -= 2
	GlobalSignals.emit_signal("health_change", health)

func poison():
	debug.text = "poison"
	health -= 2
	GlobalSignals.emit_signal("health_change", health)

func slow():
	debug.text = "slow"
	health -= 2
	GlobalSignals.emit_signal("health_change", health)

func stun():
	debug.text = "stun"
	health -= 2
	GlobalSignals.emit_signal("health_change", health)
	
func _update_sprite():
	if health_sprites.is_empty():
		return

	var stage := int((10 - health))
	stage = clamp(stage, 0, health_sprites.size() - 1)
	sprite.texture = health_sprites[stage]
