extends PanelContainer

@export var controlsPanel: PanelContainer;
@export var audioPanel: PanelContainer;


func _ready() -> void:
	visible = false;

func _on_options_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	visible = true;
	pass # Replace with function body.


func _on_optionscontrol_button_pressed() -> void:
	controlsPanel.visible = true;
	pass # Replace with function body.


func _on_optionsaudio_button_pressed() -> void:
	audioPanel.visible = true;
	pass # Replace with function body.


func _on_optionsback_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	visible = false;
	pass # Replace with function body.

func _on_controls_back_button_pressed() -> void:
	controlsPanel.visible = false;
	pass # Replace with function body.

func _on_audio_back_button_pressed() -> void:
	audioPanel.visible = false;
	pass # Replace with function body.
