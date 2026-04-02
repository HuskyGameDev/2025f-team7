extends AnimatedSprite2D

const DISTANCE := 80
const TIME := 0.75

@export var angle: float

@onready var start_position = position
@onready var timer: float = 0

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= 1: queue_free()
	
	var t := timer / TIME
	
	position = Vector2.RIGHT.rotated(angle)
	position *= DISTANCE * __ease_out_quart(t)
	
	modulate.a = 1 - t

# TODO: is there a way to avoid copy pasting this?
# https://easings.net/#easeOutQuart
func __ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)
