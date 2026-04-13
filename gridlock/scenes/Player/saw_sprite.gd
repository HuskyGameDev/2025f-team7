class_name SawSprite
extends Node2D

const ROTATION_SPEED := 180.0
const DAMAGE_ROTATION_SPEED := 450.0
const DEATH_ROTATION_DECEL := 36.0

enum State {
	DEFAULT,
	DEALING_DAMAGE,
	PLAYER_DIED,
}

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

@onready var state := State.DEFAULT
@onready var rotation_speed := ROTATION_SPEED

func _process(delta: float) -> void:
	match state:
		State.DEFAULT: rotation_speed = ROTATION_SPEED
		State.DEALING_DAMAGE: rotation_speed = DAMAGE_ROTATION_SPEED
		State.PLAYER_DIED: rotation_speed = move_toward(
			rotation_speed,
			0,
			delta * DEATH_ROTATION_DECEL
		)
	
	angle += delta * rotation_speed
