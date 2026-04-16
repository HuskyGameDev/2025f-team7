extends CharacterBody2D

const BOMB := preload("res://scenes/bomb.tscn")
const PETAL := preload("res://scenes/Player/player_petal.tscn")

signal player_position(location: Vector2)

@export_range(2, 10) var max_health := 10:
	get(): return max_health
	set(value):
		max_health = value
		health = clampi(health, 0, max_health)

var SPEED = 300.0
var SHIFTSPEED = 450
var CTRLSPEED = 150
@onready var bombs_available := 0
var invincible = false
var invincibleTimer: float = 0
const SPEED_STANDARD = 150
const BOMB_STEP = 0.01
@onready var debug = $debug
@onready var progress_bar = $ProgressBar

@onready var sprite := $PlayerSprite

var health := max_health:
	set(value):
		value = clamp(value, 0, max_health)
		if value != health:
			health = value
			progress_bar.value = value
			_update_sprite()

func _ready():
	_update_sprite()
	emit_signal("player_position", global_position)
	invincible = false
	GlobalSignals.bomb_gained.connect(_on_bomb_gained)
	GlobalSignals.boss_spawning.connect(_heal_to_full)
	GlobalSignals.boss_died.connect(_heal_to_full)

func _physics_process(_delta: float):
	if health > 0:
		var currentSpeed = SPEED
		if Input.is_action_pressed("FastWalk"):
			currentSpeed = SHIFTSPEED
		if Input.is_action_pressed("SlowWalk"):
			currentSpeed = CTRLSPEED
		if Input.is_action_just_pressed("UseBomb"):
			if bombs_available > 0:
				var bomb := BOMB.instantiate()
				bomb.global_position = global_position
				get_parent().add_child(bomb)
				bombs_available -= 1
				$Bombuse.play()
				GlobalSignals.emit_signal("bomb_used")
		
		velocity = Input.get_vector("MainPlayerMoveLeft","MainPlayerMoveRight","MainPlayerMoveUp","MainPlayerMoveDown") * currentSpeed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	GlobalSignals.emit_signal("player_position", position)

func set_status(_bullet_type):
	if invincible: return
	take_damage()
	invincible = true
	sprite.invincible = true
	$InvincibleTimer.start(5)

func take_damage():
	if health == 0: return
	health -= 2
	$Hurt.play()
	GlobalSignals.emit_signal("health_change", health)
	
	var petal := PETAL.instantiate()
	petal.color = sprite.fg.modulate
	petal.start_position = position
	petal.angle = sprite.angle + (2 * PI / 5.0) * (5 - health / 2.0)
	add_sibling(petal)
	
func _update_sprite():
	sprite.invincible = invincible
	sprite.health = ceil(health / 2.0)

func _on_invincible_timer_timeout() -> void:
	invincible = false
	sprite.invincible = false


func _on_near_miss(area: Area2D) -> void:
	if health == 0: return
	if area.near_miss: return
	area.near_miss = true
	
	if !invincible:
		GlobalSignals.emit_signal("near_miss")
		$Nearmiss.play()

func _on_bomb_gained() -> void:
	bombs_available += 1

func _on_hit(_area: Area2D) -> void:
	set_status(0)

# TODO: animation for healing?
func _heal_to_full() -> void:
	health = max_health
