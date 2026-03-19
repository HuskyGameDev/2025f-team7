extends CharacterBody2D

@export var side: int
@export var first: int
@export var hive_enemy_node: PackedScene

var counter: int = 2

func _ready():
	counter = counter - first
	pass


func spawnHive():
	var enemy = hive_enemy_node.instantiate()
	
	enemy.position = position
	enemy.startingSide = side
	
	get_tree().current_scene.call_deferred("add_child", enemy)


func _on_timer_timeout():
	print("Timeout")
	counter = counter - 1
	if (counter < 0):
		counter = 1
		spawnHive()
