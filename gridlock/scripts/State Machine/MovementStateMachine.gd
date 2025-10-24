extends Node2D


var current_state: MovementState
var previous_state: MovementState

func _ready():
	current_state = get_child(owner.starting_movement) as MovementState
	previous_state = current_state
	current_state.enter()

func change_state(state):
	if state == previous_state.name:
		return
	
	current_state = find_child(state) as MovementState
	current_state.enter()
	
	
	previous_state.exit()
	previous_state = current_state
