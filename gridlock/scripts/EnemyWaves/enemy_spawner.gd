extends Node2D

@export var spawns: PackedScene
@export var spawn_time: float = 1.0
@export var delay: float = 0.0

signal spawned(node: Node2D)

@onready var timer := -delay
@onready var start_scale: Vector2 = transform.get_scale()

func _ready() -> void:
	if timer < 0: visible = false

func _process(delta: float) -> void:
	timer += delta
	if timer >= spawn_time:
		__spawn()
		return
	
	if timer >= 0:
		visible = true
		scale = start_scale * (1 - (timer / spawn_time))

func __spawn() -> void:
	var node: Node2D = spawns.instantiate()
	node.global_position = global_position
	get_parent().add_child(node)
	emit_signal("spawned", node)
	
	
	queue_free()
