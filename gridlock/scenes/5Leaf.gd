extends State

func enter():
	super.enter()
	owner.alpha = 1.3 # angle of shots
	owner.bullet_type = 0 # color of bullet
	speed.start()


func transition():
	if can_transition:
		get_parent().change_state("4Leaf")
