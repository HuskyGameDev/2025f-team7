extends State

func enter():
	super.enter()
	owner.alpha = 1.5
	owner.bullet_type = 1 # color of bullet

func transition():
	if can_transition:
		get_parent().change_state("3Leaf")
