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
	$controlsPanel/GridContainer/VBoxContainer/mainCharacterMovementFoldable.grab_focus.call_deferred()
	controlsPanel.visible = true;
	pass # Replace with function body.


func _on_optionsaudio_button_pressed() -> void:
	audioPanel.visible = true;
	$audioPanel/GridContainer/MasterGridContainer/MasterHSlider.grab_focus.call_deferred()
	pass # Replace with function body.


func _on_optionsback_button_pressed() -> void:
	%OptionsButton.grab_focus.call_deferred()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	visible = false;
	pass # Replace with function body.

func _on_controls_back_button_pressed() -> void:
	controlsPanel.visible = false;
	$GridContainer/optionscontrolButton.grab_focus.call_deferred()
	pass # Replace with function body.

func _on_audio_back_button_pressed() -> void:
	audioPanel.visible = false;
	$GridContainer/optionscontrolButton.grab_focus.call_deferred()
	pass # Replace with function body.

func _on_save_data_button_pressed() -> void:
	DirAccess.remove_absolute("res://save_data.cfg")
