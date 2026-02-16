class_name Timeline extends Node2D

func _ready() -> void:
	call_deferred("__next_child")

func _enter_tree() -> void:
	child_entered_tree.connect(_child_entering_tree)
	child_exiting_tree.connect(_child_exiting_tree)

func __next_child() -> void:
	if get_child_count() == 0:
		queue_free()
		return
	
	var child := get_child(0)
	child.reparent(get_parent())
	child.tree_exited.connect(__next_child)
	
func _child_entering_tree(child: Node) -> void:
	child.process_mode = Node.PROCESS_MODE_DISABLED
	if child is Node2D:
		child.visible = false

func _child_exiting_tree(child: Node) -> void:
	child.process_mode = Node.PROCESS_MODE_INHERIT
	if child is Node2D:
		child.visible = true
