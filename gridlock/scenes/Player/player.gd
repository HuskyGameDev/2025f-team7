extends CharacterBody2D

signal player_position(location: Vector2)

var SPEED = 300.0
var SHIFTSPEED = 450
var CTRLSPEED = 150
const SPEED_STANDARD = 150
@onready var debug = $debug
@onready var progress_bar = $ProgressBar

@onready var sprite = $Sprite2D

@export var health_sprites: Array[Texture2D] = []

var health := 100:
	set(value):
		value = clamp(value, 0, 100)
		if value != health:
			health = value
			progress_bar.value = value
			_update_sprite()

func _physics_process(delta: float):
	var currentSpeed = SPEED
	if Input.is_action_pressed("FastWalk"):
		currentSpeed = SHIFTSPEED
	if Input.is_action_pressed("SlowWalk"):
		currentSpeed = CTRLSPEED
	if Input.is_action_just_pressed("UseBomb"):
		get_tree().call_group("Bullet", "blow_up")
	
	
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
	health -= 20

func poison():
	debug.text = "poison"
	health -= 20

func slow():
	debug.text = "slow"
	health -= 20

func stun():
	debug.text = "stun"
	health -= 20
	
func _update_sprite():
	if health_sprites.is_empty():
		return

	var stage := int((100 - health) / 10)
	stage = clamp(stage, 0, health_sprites.size() - 1)
	sprite.texture = health_sprites[stage]
