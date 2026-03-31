extends Node

signal emitted

func _process(_delta: float) -> void:
	var Mus_Main := get_node("../Mus_Main")
	Mus_Main.set_parameter("Game State", 2)
	emitted.emit()
	queue_free()
