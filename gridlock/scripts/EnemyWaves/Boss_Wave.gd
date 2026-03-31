extends Node2D

# How long to wait after the wave is complete before
# starting the next item on the Timeline
@export var delay := 0.0

@onready var timer := 0.0

func _process(delta: float) -> void:
	var Mus_Main := get_node("../Mus_Main")
	Mus_Main.set_parameter("Game State", 1)
	if get_child_count() != 0: return
	timer += delta
	if timer >= delay:
		Mus_Main.set_parameter("Game State", 0)
		queue_free()
