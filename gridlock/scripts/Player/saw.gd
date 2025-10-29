extends CharacterBody2D


const SPEED = 300.0



func _physics_process(delta: float) -> void:

	var directionx := Input.get_axis("SawPlayerMoveLeft", "SawPlayerMoveRight")
	var directiony :=Input.get_axis("SawPlayerMoveUp", "SawPlayerMoveDown")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
