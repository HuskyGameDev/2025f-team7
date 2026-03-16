extends Control

func _on_victory():
	get_tree().paused = true
	visible = true
