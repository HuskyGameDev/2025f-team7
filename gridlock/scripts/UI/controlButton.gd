"""
This script takes the key being pressed and assigns the custom input map
keys to the button that is pressed.
The export var control_name is the custom input that maps to that 
input control. (case sensitive)
"""
extends Button
@onready var config = ConfigFile.new() #creates configfile object
@export var control_name: String;
var waiting_for_input := false;

"
Calls update_text on ready
Loads input mappings from file if they are present
"
func _ready():
	var err = config.load("res://save_data.cfg")
	if err != OK:
		update_text()
	else:
		for inputs in config.get_section_keys("Inputs"):
			rebind_action(config.get_value("Inputs",inputs),inputs)
		update_text()

#If the button is pressed then it gets ready to read a key for the input event
func _pressed():
	text = "Press a key";
	waiting_for_input = true;
	
#Takes an unhandled input then calls rebind_action on it
func _unhandled_input(event: InputEvent) -> void:
	if waiting_for_input and event is InputEventKey and event.pressed:
		rebind_action(event, control_name);
		waiting_for_input = false;
"""
Rebinds the custom input to passed InputEvent & event_name
For loop purges all input events assigned to the event_name
action_add_event then adds the event to the event_name
and updates the cfg with the action
then the text is updated on the button through func
"""
func rebind_action(event: InputEventKey, event_name):
	for i in InputMap.action_get_events(event_name):
		InputMap.action_erase_event(event_name, i);
	
	InputMap.action_add_event(event_name, event);
	update_cfg(event_name,event)
	
	update_text();

#Adds the Input mappings to the cfg file
func update_cfg(event_name, event: InputEventKey):
	config.load("res://save_data.cfg")
	config.set_value("Inputs",event_name,event)
	config.save("res://save_data.cfg")

#May Not 100% work might need to iterate through events even 
#though 1 key should be bound at a time
#Updates text on the button
func update_text():
	var events = InputMap.action_get_events(control_name);
	if(events.size() > 0 and events[0] is InputEventKey):
		text = events[0].as_text();
	else:
		text = "Unbound";
