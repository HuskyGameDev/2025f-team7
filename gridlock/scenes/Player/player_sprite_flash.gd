extends Node2D

func _process(delta: float) -> void:
	modulate.a -= delta
	if modulate.a <= 0: queue_free()
	
	rotation += delta
	scale += Vector2.ONE * delta
