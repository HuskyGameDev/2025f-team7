extends Node

func _ready():
	GlobalSignals.boss_died.connect(_boss_died)

func _boss_died():
	# I am so sorry (the _ready function still runs on disabled
	# nodes, so this connection still runs when the container is
	# not currently active)
	if process_mode == ProcessMode.PROCESS_MODE_DISABLED: return
	
	# The bullets from the boss aren't parented to the container,
	# so freeing it won't get rid of them. This will! :]
	# (deferring it makes sure bullets spawned this frame will
	#  also blow up)
	get_tree().call_deferred("call_group", "Bullet", "blow_up")
	queue_free()
