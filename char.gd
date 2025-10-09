extends CharacterBody2D


var SPEED = 300.0
var SHIFTSPEED = 450
var CTRLSPEED = 150

func _physics_process(delta: float) -> void:

	#Handle jump.
	#We determine which speed to use here
	#Just a simple check of if we are hitting Shift
	var currentSpeed = SPEED
	if Input.is_action_pressed("go_Fast"):
		currentSpeed = SHIFTSPEED
	if Input.is_action_pressed("go_Slow"):
		currentSpeed = CTRLSPEED
		
	#Get the direction based on inputs
	var directionx := Input.get_axis("left", "right")
	var directiony :=Input.get_axis("up", "down")

	if directionx:
		velocity.x = directionx * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
	if directiony:
		velocity.y = directiony * currentSpeed
	else:
		velocity.y = move_toward(velocity.y, 0, currentSpeed)
	

	move_and_slide()
