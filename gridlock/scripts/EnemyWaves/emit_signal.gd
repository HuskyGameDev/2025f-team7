extends Node

signal emitted

func _process(_delta: float) -> void:
	emitted.emit()
	queue_free()
