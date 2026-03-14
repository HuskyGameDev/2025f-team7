extends State

@onready var timer: float

func enter():
	super.enter()
	owner.get_node("Speed").stop()

func _physics_process(_delta: float) -> void:
	var dist: float = (owner.pos - owner.global_position).length()
	if dist < 10:
		get_parent().change_state("BurstFlower")
