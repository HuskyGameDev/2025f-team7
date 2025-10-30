extends Label


var change_interval := 1;
var text_list := ["Boss Inbound", "3...", "2...", "1..."];

var _timer := 0.0;
#var _visible := false;
var _curr_idx := 0;
var _active := false;

func _ready():
	text = text_list[_curr_idx];
	visible = false;
	
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
			
			
func activate_label():
	_active = true
	visible = true;
	get_tree().paused = true;
