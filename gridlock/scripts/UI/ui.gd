"""
Signals to listen for(From Global to UI):
	health_change -> _on_player_health_change
	near_miss -> _near_Miss_Bomb
	bomb_used -> _bomb_Used
	enemy_progress -> _update_waveprogressbar
	
Signals sent out(From UI to Global):
	_bomb_Used -> bomb_used
	_update_waveprogressbar -> progress_bar_full()
"""

extends Control

var currentHealth := 5;
var heartTextures := [];

var bombs := 0;

var time := 0.0;
var stopped := false;

var testVar := false;
signal bossInbound;

@export var full_heart: Texture;
@export var empty_heart: Texture;
@export var timeLabel: Label;
@export var bombPBar: ProgressBar;
@export var bombLabel: Label;
@export var mainPausePanel: PanelContainer;
@export var optionsPanel: PanelContainer;
@export var controlsPanel: PanelContainer;
@export var waveProgressLabel: Label;
@export var waveProgressBar: ProgressBar;
@export var audioPanel: PanelContainer;
@export var HeartContainer: GridContainer;
@export var HeartTextureRect: TextureRect;



func _ready() -> void:
	for i in range(currentHealth-1):
		var clone = HeartTextureRect.duplicate();
		clone.name = "HeartTexture" + str(i+1)
		HeartContainer.add_child(clone);
	heartTextures = get_tree().get_nodes_in_group("heartsGroup");
	
	var regex = RegEx.new()
	regex.compile("\\d+")
	heartTextures.sort_custom(func(a, b): return int(regex.search(a.name).get_string()) < int(regex.search(b.name).get_string()));
	
	bombPBar.value = 0;
	
	GlobalSignals.connect("health_change", Callable(self, "_on_player_health_change"));
	GlobalSignals.connect("near_miss", Callable(self, "_near_Miss_Bomb"));
	GlobalSignals.connect("bomb_used", Callable(self, "_bomb_Used"));
	GlobalSignals.connect("enemy_progress", Callable(self, "_update_waveprogressbar"));

func _process(delta: float) -> void:
	#if testVar==false:
		#_on_player_health_change(5);
		#testVar=true
	if stopped||get_tree().paused:
		return
	time += delta;
	timeLabel.text = _time_to_String();

#activated by GlobalSignals
func _on_player_health_change(new_health) -> void:
	var temp := int(new_health/2);
	if(temp >= 0 and temp <= 5):	
		if(currentHealth < temp):
			currentHealth = temp;
			heartTextures[currentHealth-1].texture = full_heart;

		elif (currentHealth > temp):
			currentHealth = temp;
			heartTextures[currentHealth-1].texture = empty_heart;

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
		if(bombPBar.value>=100):
			bombs += 1;
			bombLabel.text = "x" + str(bombs);
			bombPBar.value = 0;
			GlobalSignals.emit_signal("bomb_gained");

#activated by global signals
func _bomb_Used() -> void:
	bombs -= 1;

#activated by global signals
func _update_waveprogressbar(increase: int) -> void:
	if(waveProgressBar.visible):
		waveProgressBar.value += increase;
		if(waveProgressBar.volume >= 100):
			waveProgressBar.visible = false;
			waveProgressLabel.visible = false;
			GlobalSignals.emit_signal("progress_bar_full");
			emit_signal("bossInbound");

#Handles inputs for ui_cancel.
func _input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("ui_cancel")):
		if(audioPanel.visible):
			audioPanel.visible = false;
		elif(controlsPanel.visible):
			controlsPanel.visible = false;
		elif(optionsPanel.visible):
			optionsPanel.visible = false;
		elif(mainPausePanel.visible):
			mainPausePanel.visible = false;
			stopped = false;
			get_tree().paused = false;
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;	
		elif(not mainPausePanel.visible):
			mainPausePanel.visible = true;
			stopped = true;
			get_tree().paused = true;
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		

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
func _on_optionscontrol_button_pressed() -> void:
	controlsPanel.visible = true;
#Options Panel Button
func _on_optionsaudio_button_pressed() -> void:
	audioPanel.visible = true;
#Options Panel Button
func _on_optionsback_button_pressed() -> void:
	optionsPanel.visible = false;

#Controls Panel Button
func _on_controls_back_button_pressed() -> void:
	controlsPanel.visible = false;

#Audio Panel Button
func _on_audio_back_button_pressed() -> void:
	audioPanel.visible = false;
