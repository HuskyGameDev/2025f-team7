extends Node

signal emitted

func _process(_delta: float) -> void:
	# TODO: we can't do the music trigger here, since this
	# is a general-purpose script for running signals in the
	# timeline (it's also being used for triggering the boss
	# 2 intro animation)
	# var Mus_Main := get_node("../Mus_Main")
	# Mus_Main.set_parameter("Game State", 2)
	emitted.emit()
	queue_free()
