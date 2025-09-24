extends State

func enter():
	super.enter()
	owner.alpha = 0.8 # angle of shots
	owner.bullet_type = 0 # color of bullet
	owner.speed = 70
	speed.start()


func transition():
	if can_transition:
		get_parent().change_state("Fast2Leaf")
