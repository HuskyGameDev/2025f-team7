extends Button

@export var control_name: String;
var waiting_for_input := false;

func _ready():
	update_text();
	
func _pressed():
	text = "Press a key";
	waiting_for_input = true;
	
func _unhandled_input(event: InputEvent) -> void:
	if waiting_for_input and event is InputEventKey and event.pressed:
		rebind_action(event);
		waiting_for_input = false;
func rebind_action(event: InputEventKey):
	for i in InputMap.action_get_events(control_name):
		InputMap.action_erase_event(control_name, i);
	
	InputMap.action_add_event(control_name, event);
	
	update_text();

#May Not 100% work might need to iterate through events even 
#though 1 key should be bound at a time
func update_text():
	var events = InputMap.action_get_events(control_name);
	if(events.size() > 0 and events[0] is InputEventKey):
		text = events[0].as_text();
	else:
		text = "Unbound";
