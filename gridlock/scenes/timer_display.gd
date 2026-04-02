class_name TimerDisplay
extends Control

@export var time: float = 0.0

@onready var percent_1: AnimatedSprite2D = $Percent1
@onready var percent_2: AnimatedSprite2D = $Percent2
@onready var seconds_1: AnimatedSprite2D = $Second1
@onready var seconds_2: AnimatedSprite2D = $Second2
@onready var minutes_1: AnimatedSprite2D = $Minute1
@onready var minutes_2: AnimatedSprite2D = $Minute2

func _process(_delta: float) -> void:
	var percent := floori(time * 100) % 100
	var seconds := floori(time) % 60
	var minutes := floori(time / 60)
	
	percent_1.animation = str(percent % 10)
	@warning_ignore("integer_division")
	percent_2.animation = str(percent / 10)
	
	seconds_1.animation = str(seconds % 10)
	@warning_ignore("integer_division")
	seconds_2.animation = str(floori(seconds / 10))
	
	minutes_1.animation = str(minutes % 10)
	@warning_ignore("integer_division")
	minutes_2.animation = str(floori(minutes / 10))
