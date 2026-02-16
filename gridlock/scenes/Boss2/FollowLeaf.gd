extends State

func enter():
	super.enter()
	owner.alpha = -0.8
	owner.bullet_type = 3 # color of bullet
	owner.speed = 100
	speed.start()


func transition():
	if can_transition:
		get_parent().change_state("FollowLeaf")
