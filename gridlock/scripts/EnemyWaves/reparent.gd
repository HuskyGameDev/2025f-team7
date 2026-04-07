extends Node

# this allows you to place a node in the scene *without* waiting for
# it to be freed. currently this is only used for boss 2

func _process(_delta: float) -> void:
	for child in get_children(): child.reparent(get_parent())
	queue_free()
