extends Sprite2D

@export_range(0, 720, 10) var spin_speed: float = 180.0 # adjustable slider in inspector

func _process(delta: float) -> void:
	rotation_degrees += spin_speed * delta
