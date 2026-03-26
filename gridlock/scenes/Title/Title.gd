extends Control

@onready var color_picker = $ColorPicker
@onready var config = ConfigFile.new() #creates configfile object

#hides cursor
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var err = config.load("res://save_data.cfg")
	if err != OK:
		pass
	elif (config.has_section("Timer")):
		var time = config.get_value("Timer","best_time")
		var timer_value = "Best Time: " + str(snapped(time, 0.01))
		$BestTime.set_text(timer_value)

#Switches to the Main scene when StartButton is pressed
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_room.tscn")

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scripts/Tutorial/tutorial.tscn")
	
#Currently not implemented until we get a finished options menu, but will open said options menu when pressed
func _on_options_button_pressed() -> void:
	pass # Replace with function body.

#Ends the 
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
# hides and unhides the colorpicker
func _on_color_button_pressed() -> void:
	# Toggle the visibility of the color wheel
	color_picker.visible = not color_picker.visible

# for all button sounds
func _on_button_mouse_entered() -> void:
	var button_hover := get_node("ButtonHover")
	if button_hover: button_hover.play()
