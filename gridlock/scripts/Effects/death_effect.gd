extends Node2D

const PARTICLE := preload("res://scenes/Effects/death_particle.tscn")
const PARTICLE_COUNT := 8

@export var color: Color = Color.WHITE

@onready var die := $Enemy_Die
@onready var particles := PARTICLE_COUNT

func _ready() -> void:
	die.play()
	for i in range(0, PARTICLE_COUNT):
		var particle := PARTICLE.instantiate()
		particle.angle = i * 2 * PI / PARTICLE_COUNT
		particle.modulate = color
		add_child(particle)
		particle.tree_exiting.connect(_particle_freed)

func _particle_freed() -> void:
	particles -= 1
	if particles == 0: queue_free()
