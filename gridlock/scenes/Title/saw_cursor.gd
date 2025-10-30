extends Sprite2D

@export_range(0, 720, 10)
var spin_speed: float = 180.0 # adjustable slider in inspector

func _process(delta: float) -> void:
	# make it follow the cursor
	position = get_global_mouse_position()

	# make it spin
	rotation_degrees += spin_speed * delta
