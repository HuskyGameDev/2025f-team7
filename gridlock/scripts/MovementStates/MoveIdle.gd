extends MovementState

var start_pos: Vector2

func enter():
	super.enter()
	owner.t = 0
	start_pos = owner.global_position

func _physics_process(delta: float) -> void:
	owner.t += delta
	if owner.t >= 1:
		owner.global_position = owner.pos
		return
	
	var progress := __ease_out_quart(owner.t)
	var diff: Vector2 = owner.pos - start_pos
	owner.global_position = start_pos + progress * diff

# https://easings.net/#easeOutQuart
func __ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)
