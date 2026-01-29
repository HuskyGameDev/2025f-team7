extends CharacterBody2D

var laser_scene = preload("res://scenes/basicEnemies/laser.tscn")


var target: Vector2
var shape: ConvexPolygonShape2D

func _ready():
	GlobalSignals.connect("player_position", Callable(self, "_track"))
	while(true):
		await get_tree().create_timer(5.0).timeout
		laser(3, 4, target.x, target.y, 0)

func _track(location: Vector2):
	target = location

func laser(time1: float, time2: float, x: float, y: float, rotation: float):
	var instance = laser_scene.instantiate()
	add_child(instance)
	instance.global_position = Vector2(x,y)
	instance.rotation = rotation
	pass
