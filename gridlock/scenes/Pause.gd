extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _on_button_mouse_entered() -> void:
	$ButtonHover.play()
