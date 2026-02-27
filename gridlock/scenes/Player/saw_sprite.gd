extends Node2D

@onready var bg: AnimatedSprite2D = $Background
@onready var outline: AnimatedSprite2D = $Outline
@onready var color: AnimatedSprite2D = $Color
@onready var shadow: AnimatedSprite2D = $Shadow

const ROTATION_SPEED := 180.0

func _process(delta: float) -> void:
	outline.rotation_degrees += delta * ROTATION_SPEED
	bg.rotation_degrees += delta * ROTATION_SPEED
	color.rotation_degrees += delta * ROTATION_SPEED
	shadow.rotation_degrees += delta * ROTATION_SPEED
