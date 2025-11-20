extends State

func enter():
	super.enter()
	speed.stop()


func transition():
	if can_transition:
		get_parent().change_state("TurretLeaf")
