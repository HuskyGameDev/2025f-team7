class_name Enemy
extends CharacterBody2D

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
		if player_detection == value: return
		
		if player_detection:
			player_detection.body_entered.disconnect(_on_body_entered)
			player_detection.body_exited.disconnect(_on_body_exited)
		
		player_detection = value
		if player_detection:
			player_detection.body_entered.connect(_on_body_entered)
			player_detection.body_exited.connect(_on_body_exited)

@onready var taking_damage := false

var target: Vector2 = Vector2.ZERO

func _init() -> void:
	GlobalSignals.player_position.connect(_on_player_position)

func _ready() -> void:
	player_detection = get_node_or_null("PlayerDetection")

func _process(delta: float) -> void:
	if taking_damage:
		health -= 10 * delta
	
	if health == 0.0:
		emit_signal("died")
		queue_free()

func _on_body_entered(_body: PhysicsBody2D) -> void:
	taking_damage = true

func _on_body_exited(_body: PhysicsBody2D) -> void:
	taking_damage = false

func _on_player_position(pos: Vector2) -> void:
	target = pos
