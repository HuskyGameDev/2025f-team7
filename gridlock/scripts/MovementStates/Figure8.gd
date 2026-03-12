extends MovementState

func enter():
	super.enter()
	owner.t = 0

func _physics_process(delta):
	owner.t += delta * owner.move_speed
	var x = owner.move_size * sin(owner.t)
	var y = owner.move_size * sin(owner.t) * cos(owner.t)
	owner.global_position = owner.pos + Vector2(x,y)
