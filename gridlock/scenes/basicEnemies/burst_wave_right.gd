extends State

@onready var burstDelay = owner.find_child("BurstDelay")

var counter: int

func enter():
	super.enter()
	owner.position = owner.position + Vector2(-1300, 0)
	counter = 0
	owner.bullet_type = 0 # color of bullet
	owner.alpha = 0
	# write out burst pattern
	can_transition = false
	burstDelay.start()

func _on_burst_delay_timeout():
	owner.burst(9, 6, 50, 100, 0, (60*counter))
	owner.burst(9, 6, 50, 100, 0, (-60*counter))
	counter = counter + 1
	if (counter > 10):
		can_transition = true

func transition():
	if can_transition:
		burstDelay.stop()
		counter = 0
		can_transition = false
		get_parent().change_state("BurstWaveLeft")
