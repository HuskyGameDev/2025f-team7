extends Node2D

@onready var sprite := $BackgroundWip

# TODO: hardcoded :\
const ARENA_WIDTH := 1782
const VIEWPORT_WIDTH := 1920
const VIEWPORT_HEIGHT := 1080

func _process(_delta: float) -> void:
	var rect := get_viewport_rect()
	
	# TODO: hardcoded again.. -_-
	scale = Vector2.ONE * maxf(
		rect.size.x / VIEWPORT_WIDTH,
		rect.size.y / VIEWPORT_HEIGHT
	)
	
	position.x = rect.size.x - scale.x * ARENA_WIDTH - (VIEWPORT_WIDTH - ARENA_WIDTH)
