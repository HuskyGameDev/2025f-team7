extends Node2D

@onready var bg: AnimatedSprite2D = $Background
@onready var outline: AnimatedSprite2D = $Outline
@onready var color: AnimatedSprite2D = $Color
@onready var shadow: AnimatedSprite2D = $Shadow

@onready var angle := 0.0:
	get(): return angle
	set(value):
		angle = fmod(value, 360)
		
		outline.rotation_degrees = angle
		bg.rotation_degrees = angle
		color.rotation_degrees = angle
		shadow.rotation_degrees = angle

@onready var dealing_damage := false

const ROTATION_SPEED := 180.0
const DAMAGE_ROTATION_SPEED := 450.0

func _process(delta: float) -> void:
	if dealing_damage:
		angle += delta * DAMAGE_ROTATION_SPEED
	else:
		angle += delta * ROTATION_SPEED
