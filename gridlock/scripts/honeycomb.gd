extends Sprite2D

# TODO: don't hardcode...
const START_X := 700.0

@onready var target_x := global_position.x
@onready var t := 0.0

func _ready() -> void:
	global_position.x = START_X

func _process(delta: float) -> void:
	t = move_toward(t, 1.0, delta / 2)
	global_position.x = lerp(START_X, target_x, __ease_out_quart(t))


func __ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)
