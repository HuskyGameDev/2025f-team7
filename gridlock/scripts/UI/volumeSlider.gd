"""
(Untested do to no sound being in the game)
Multi-Purpose script for controlling volume busses.
For the two export vars the first one is for the HSlider itself
	For the second is the name of the audio bus that you want
	the slider to change. (It is case sensative I think)
"""
extends HSlider

@export var volSlider: HSlider;
@export var selectedBus: String;
var bus_idx: int

"""
On ready it gets the bus index for the selected bus.
Then it connects the HSliders volume change signal to the first function
It then gets the current volume of the audio bus and runs it through the db to val
function and sets the slider to where it should be
"""
func _ready():
	bus_idx = AudioServer.get_bus_index(selectedBus);
	volSlider.connect("value_changed", Callable(self, "_on_volSlider_change"))
	var volumeValue = AudioServer.get_bus_volume_db(bus_idx);
	volSlider.value = _db_to_value(volumeValue);
	
"""
Starts with simple logic that mutes and unmutes the audio bus depending
on level of the slider
Get the level the slider is set to and converts that to db through the val to db func
Then sets the db volume of that bus index
"""
func _on_volSlider_change(volValue: int) -> void:
	if(volValue < 1):
		AudioServer.set_bus_mute(bus_idx, true);
		return
	elif(AudioServer.is_bus_mute(bus_idx) && volValue >= 1):
		AudioServer.set_bus_mute(bus_idx, false);
		
	var dbValue = _value_to_db(volValue);
	AudioServer.set_bus_volume_db(bus_idx, dbValue);
	
#Used to convert db to a useable volume for slider
func _db_to_value(dbVal: float) -> int:
	return int((((dbVal + 80)/86)*100));

#Used to convert volume of slider to a useable db for audio bus
func _value_to_db(vValue: int) -> float:
	return float((-80 + pow(vValue/100.0, 2.0) * 86))
