extends Node2D

const DISTANCE := 60
const TIME := 0.75

@export var angle: float
@export var start_position: Vector2
@export var color: Color

@onready var timer: float = 0

@onready var background := $Background
@onready var foreground = $Foreground

func _ready() -> void:
	background.rotation = angle
	foreground.rotation = angle
	foreground.modulate = color
	foreground.modulate.a = 0.5

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= 1: queue_free()
	
	var t := timer / TIME
	
	position = Vector2.UP.rotated(angle)
	position *= DISTANCE * __ease_out_quart(t)
	position += start_position
	
	modulate.a = 1 - t

# TODO: is there a way to avoid copy pasting this?
# https://easings.net/#easeOutQuart
func __ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)
