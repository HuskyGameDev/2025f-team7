extends Enemy

@export var speed: float

var target_pos: Vector2

func _ready() -> void:
	super._ready()
	
	GlobalSignals.player_position.connect(_player_position)

func _player_position(pos: Vector2):
	target_pos = pos

func _physics_process(delta: float) -> void:
	var diff := target_pos - global_position
	var distance := (global_position - target_pos).length()
	var direction := diff.normalized()
	
	if distance < speed * delta:
		global_position = target_pos
	else:
		global_position += direction * speed * delta
