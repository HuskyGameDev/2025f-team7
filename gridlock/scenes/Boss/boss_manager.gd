extends Node2D

@export var victory_screen: NodePath

func _ready():
	add_to_group("game")



func on_victory():
	
	get_tree().paused = true
	
	get_node(victory_screen).visible = true
