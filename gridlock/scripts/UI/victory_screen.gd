extends Control


func _ready() -> void:
	visible = false;
	
func _process(delta: float) -> void:
	if(visible):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		

func _on_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://scripts/EnemyWaves/waves_for_playtest/waves_2.tscn")
