extends HSlider

@export var volSlider: HSlider;
@export var selectedBus: String;
var bus_idx: int

func _ready():
	bus_idx = AudioServer.get_bus_index(selectedBus);
	volSlider.connect("value_changed", Callable(self, "_on_volSlider_change"))
	var volumeValue = AudioServer.get_bus_volume_db(bus_idx);
	volSlider.value = _db_to_value(volumeValue);
	
func _on_volSlider_change(volValue: int) -> void:
	if(volValue < 1):
		AudioServer.set_bus_mute(bus_idx, true);
		return
	elif(AudioServer.is_bus_mute(bus_idx) && volValue >= 1):
		AudioServer.set_bus_mute(bus_idx, false);
		
	var dbValue = _value_to_db(volValue);
	AudioServer.set_bus_volume_db(bus_idx, dbValue);
	

func _db_to_value(dbVal: float) -> int:
	return int((((dbVal + 80)/86)*100));

func _value_to_db(vValue: int) -> float:
	return float((-80 + pow(vValue/100.0, 2.0) * 86))
