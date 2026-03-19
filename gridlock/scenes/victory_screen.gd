extends Control

@onready var config = ConfigFile.new() #creates configfile object


func _on_victory():
	var time = get_node("../UI").time
	var err = config.load("res://save_data.cfg")
	if err != OK:
		pass
	elif (config.has_section_key("Timer","best_time")):
		if (time < config.get_value("Timer","best_time")):
			config.set_value("Timer","best_time",time)
	else:
		config.set_value("Timer","best_time",time)
	get_tree().paused = true
	visible = true
	config.save("res://save_data.cfg")
