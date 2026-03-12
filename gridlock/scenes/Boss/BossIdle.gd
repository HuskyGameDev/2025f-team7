extends State

@onready var timer: float = 0.0

func transition():
	get_parent().change_state("BossIdle")
