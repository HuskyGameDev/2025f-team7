"""
This is signaled through global signal boss_inbound_pause.
Currently nothing attaches to this global signal.
Currently activated by bossInbound signal from UI script

This script displays text that lets the player know that
there is a boss spawn.
It pauses execution during the time the text is being displayed
"""

extends Label


var change_interval := 1;#In seconds on how fast the text should change
var text_list := ["Boss Inbound", "3...", "2...", "1..."];#Text to dispaly
var _timer := 0.0;#timer script uses
#var _visible := false;
var _curr_idx := 0;#Current index for text list
var _active := false;#If the script is running

#Sets text on label to the first index
#Make sure visible is set to false
#Connect boss_inbound_pause signal to the activate_label function
func _ready():
	text = text_list[_curr_idx];
	visible = false;
	GlobalSignals.connect("boss_inbound_pause", Callable(self, "activate_label"));

"""
If the label sequence hasn't been activated this does nothing
This function keeps track of current time and increment the list of words
"""
func _process(delta):
	if not _active:
		return
		
	_timer += delta;
	if (_timer >= change_interval):
		_timer = 0;
		
		if(visible):
			if(_curr_idx == text_list.size()-1):
				_active = false;
				visible = false;
				_curr_idx = 0;
				text = text_list[_curr_idx];
				get_tree().paused = false;
				return
				
			_curr_idx = (_curr_idx+1) % text_list.size();
			text = text_list[_curr_idx];
			
#Sets the label as active and make it visible
#Also pauses the scene tree
func activate_label():
	_active = true
	visible = true;
	get_tree().paused = true;
