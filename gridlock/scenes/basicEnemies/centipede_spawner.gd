extends Node

const CENTIPEDE := preload("res://scenes/basicEnemies/centipede.tscn")
const CENTIPEDE_RADIUS := 100

# TODO: hardcoded :(
const SCREEN_SIZE := Vector2(1920, 1080)

const LEFT_EDGE := 0 - CENTIPEDE_RADIUS
const TOP_EDGE := 0 - CENTIPEDE_RADIUS
const RIGHT_EDGE := SCREEN_SIZE.x + CENTIPEDE_RADIUS
const BOTTOM_EDGE := SCREEN_SIZE.y + CENTIPEDE_RADIUS

func force_spawn():
	var corner := randi_range(0, 3)
	
	var centipede := CENTIPEDE.instantiate()
	match corner:
		0: centipede.global_position = Vector2(
			LEFT_EDGE,
			randf_range(TOP_EDGE, BOTTOM_EDGE)
		)
		1: centipede.global_position = Vector2(
			RIGHT_EDGE,
			randf_range(TOP_EDGE, BOTTOM_EDGE)
		)
		2: centipede.global_position = Vector2(
			randf_range(LEFT_EDGE, RIGHT_EDGE),
			TOP_EDGE
		)
		3: centipede.global_position = Vector2(
			randf_range(LEFT_EDGE, RIGHT_EDGE),
			BOTTOM_EDGE
		)
	get_tree().current_scene.add_child(centipede)
