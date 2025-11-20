extends State



func transition():
	get_parent().change_state("BossIdle")
