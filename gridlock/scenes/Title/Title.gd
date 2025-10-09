extends Control

#Switches to the Main scene when StartButton is pressed
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Boss/boss_room.tscn")

#Currently not implemented until we get a finished options menu, but will open said options menu when pressed
func _on_options_button_pressed() -> void:
	pass # Replace with function body.

#Ends the 
func _on_quit_button_pressed() -> void:
	get_tree().quit()
