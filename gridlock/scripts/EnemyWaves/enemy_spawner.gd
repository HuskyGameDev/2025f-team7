extends Node2D

@export var spawns: PackedScene
@export var spawn_time: float

signal spawned(node: Node2D)

@onready var timer := 0.0



func _process(delta: float) -> void:
	timer += delta
	if timer >= spawn_time:
		__spawn()
		return
	
	scale = Vector2.ONE * (1 - (timer / spawn_time))

func __spawn() -> void:
	var node: Node2D = spawns.instantiate()
	get_parent().add_child(node)
	emit_signal("spawned", node)
	
	node.global_position = global_position
	queue_free()
