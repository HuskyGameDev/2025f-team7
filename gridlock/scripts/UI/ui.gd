"""
Signals to listen for(From Global to UI):
	health_change -> _on_player_health_change
	near_miss -> _near_Miss_Bomb
	bomb_used -> _bomb_Used
	
Signals sent out(From UI to Global):
	_bomb_Used -> bomb_used
"""

extends Control

var currentHealth := 6;
var heartTextures := [];

var bombs := 0;

var time := 0.0;
var stopped := false;

var testVar := false;

@export var full_heart: Texture;
@export var empty_heart: Texture;
@export var timeLabel: Label;
@export var bombPBar: ProgressBar;
@export var bombLabel: Label;
@export var mainPausePanel: PanelContainer;
@export var optionsPanel: PanelContainer;
@export var controlsPanel: PanelContainer;


func _ready() -> void:
	heartTextures = get_tree().get_nodes_in_group("heartsGroup");
	heartTextures.sort_custom(func(a, b): return a.name > b.name);
	bombPBar.value = 0;
	GlobalSignals.connect("health_change", Callable(self, "_on_player_health_change"));
	GlobalSignals.connect("near_miss", Callable(self, "_near_Miss_Bomb"));
	GlobalSignals.connect("bomb_used", Callable(self, "_bomb_Used"));
func _process(delta: float) -> void:
	#if testVar==false:
		#_on_player_health_change(5);
		#testVar=true
	if stopped:
		return
	time += delta;
	timeLabel.text = _time_to_String();

#activated by GlobalSignals
func _on_player_health_change(new_health) -> void:
	if(new_health >= 0 and new_health <= 6):	
		if(currentHealth < new_health):
			currentHealth = new_health;
			heartTextures[currentHealth].texture = full_heart;

		elif (currentHealth > new_health):
			currentHealth = new_health;
			heartTextures[currentHealth].texture = empty_heart;

		else:
			return

func _time_to_String() -> String:
	var milisec = fmod(time, 1) * 100;
	var seconds = fmod(time, 60);
	var minutes = time/60;
	var format_S = "%02d:%02d:%02d";
	var complete_string = format_S % [minutes, seconds, milisec];
	return complete_string;

#Should be called on a near miss to increase bomb bar
#activated by GlobalSignals
func _near_Miss_Bomb() -> void:
	if(bombs<2):
		bombPBar.value += 10;
		if(bombPBar.volume>=100):
			bombs += 1;
			bombLabel.text = "x" + str(bombs);
			bombPBar.value = 0;
			GlobalSignals.emit_signal("bomb_gained");

#activated by global signals
func _bomb_Used() -> void:
	bombs -= 1;

#Handles inputs for ui_cancel.
func _input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().set_input_as_handled()
		if(controlsPanel.visible):
			controlsPanel.visible = false;
		elif(optionsPanel.visible):
			optionsPanel.visible = false;
		elif(not mainPausePanel.visible):
			mainPausePanel.visible = true;
			stopped = true;
			get_tree().paused = true;
		elif(mainPausePanel.visible):
			mainPausePanel.visible = false;
			stopped = false;
			get_tree().paused = false;

#Main Pause Panel Button
func _on_resume_button_pressed() -> void:
	mainPausePanel.visible = false;
	stopped = false;
	get_tree().paused = false;
#Main Pause Panel Button
func _on_option_button_pressed() -> void:
	optionsPanel.visible = true;
	print("TEST")
#Main Pause Panel Button
func _on_quit_button_pressed() -> void:
	#This will be quit logic
	pass # Replace with function body.

#Options Panel Button
func _on_optionsback_button_pressed() -> void:
	optionsPanel.visible = false;
#Options Panel Button
func _on_optionscontrol_button_pressed() -> void:
	controlsPanel.visible = true;

#Controls Panel Button
func _on_controls_back_button_pressed() -> void:
	controlsPanel.visible = false;
