extends State

func enter():
	super.enter()
	owner.bullet_type = 1 # color of bullet
	owner.alpha = 0
	# write out burst pattern
	owner.burst(8, 6, 100, 300)
	can_transition = true
	

func transition():
	if can_transition:
		get_parent().change_state("Slow8Leaf")
