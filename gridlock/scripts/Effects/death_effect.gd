extends Node2D

const PARTICLE := preload("res://scenes/Effects/death_particle.tscn")

@export var color: Color = Color.WHITE

func _ready() -> void:
	var die = get_node("Enemy_Die")
	die.play()
	for i in range(0, 8):
		var particle := PARTICLE.instantiate()
		particle.angle = i * PI / 4
		particle.modulate = color
		add_child(particle)

func _process(_delta: float) -> void:
	if get_child_count() == 0:
		queue_free()
