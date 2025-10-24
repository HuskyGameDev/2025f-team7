extends MovementState
var isRunning: bool = false

func enter():
	super.enter()
	isRunning = true

func _process(delta):
	if (isRunning):
		owner.t += delta * owner.move_speed
		var x = owner.move_size * sin(owner.t)
		var y = owner.move_size * sin(owner.t) * cos(owner.t)
		owner.global_position = owner.pos + Vector2(x,y)
