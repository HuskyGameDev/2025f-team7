extends Enemy

@export var speed: float

func _physics_process(delta: float) -> void:
	var diff := target - global_position
	var distance := (global_position - target).length()
	var direction := diff.normalized()
	
	if distance < speed * delta:
		global_position = target
	else:
		global_position += direction * speed * delta
