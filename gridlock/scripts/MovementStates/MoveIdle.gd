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
	
	owner.global_position = start_pos + owner.t * (owner.pos - start_pos)
