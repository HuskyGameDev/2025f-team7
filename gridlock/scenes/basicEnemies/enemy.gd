class_name Enemy
extends Node2D

signal health_changed(new_health: float)
signal died

@export var max_health: float

@onready var health := max_health:
	get(): return health
	set(value):
		value = clampf(value, 0.0, max_health)
		if health == value: return
		
		health = value
		emit_signal("health_changed", health)

var player_detection: Area2D:
	get(): return player_detection
	set(value):
		print("setter triggered")
		if player_detection == value: return
		print("value is different")
		
		if player_detection:
			print("disconnecting old one")
			player_detection.body_entered.disconnect(_on_body_entered)
			player_detection.body_exited.disconnect(_on_body_exited)
		
		player_detection = value
		if player_detection:
			print("connecting new one")
			player_detection.body_entered.connect(_on_body_entered)
			player_detection.body_exited.connect(_on_body_exited)

@onready var taking_damage := false

var target: Vector2 = Vector2.ZERO

func _init() -> void:
	GlobalSignals.player_position.connect(_on_player_position)

func _ready() -> void:
	print("_ready")
	player_detection = get_node("PlayerDetection")
	assert(player_detection)

func _process(delta: float) -> void:
	if taking_damage:
		health -= 10 * delta
	
	if health == 0.0:
		emit_signal("died")
		queue_free()

func _on_body_entered(_body: PhysicsBody2D) -> void:
	print("taking damage!!!")
	taking_damage = true

func _on_body_exited(_body: PhysicsBody2D) -> void:
	taking_damage = false

func _on_player_position(pos: Vector2) -> void:
	target = pos
