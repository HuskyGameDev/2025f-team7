extends Enemy

@onready var anim_timer := 0.0

func _physics_process(delta: float) -> void:
	anim_timer += 2 * PI * delta / 6
	
	position += 5 * Vector2(
		cos(anim_timer),
		sin(1.667 * anim_timer)
	) * delta
