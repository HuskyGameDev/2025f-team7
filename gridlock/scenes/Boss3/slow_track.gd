extends State

func enter():
	super.enter()
	owner.bullet_type = 3 # color of bullet
	owner.alpha = 0
	# write out burst pattern
	owner.tracking = true


func transition():
	if can_transition:
		get_parent().change_state("SlowTrack")
