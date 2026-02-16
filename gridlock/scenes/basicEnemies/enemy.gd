class_name Enemy
extends Area2D

@export var MAX_HEALTH: float

@onready var health := MAX_HEALTH:
	get(): return health
	set(value):
		health = clampf(value, 0.0, MAX_HEALTH)

@onready var taking_damage := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if taking_damage:
		print("aaa i am taking damage")
		health -= delta
	
	if health == 0.0:
		queue_free()

func _on_body_entered(_body: PhysicsBody2D) -> void:
	print("woah! area entered!")
	taking_damage = true

func _on_body_exited(_body: PhysicsBody2D) -> void:
	print("woah! area exited!")
	taking_damage = false
