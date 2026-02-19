extends Node

@export var scene: PackedScene

func _process(_delta: float) -> void:
	get_tree().change_scene_to_packed(scene)
