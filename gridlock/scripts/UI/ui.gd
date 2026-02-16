"""
Scipt for most of the UI functions.
There are 3 other UI scripts:
	boss_inbound_text.gd - Used in WaveProgressBar
	controlButton.gd - Used in controlsPanel
	volumeSlider.gd - Used in audioPanel

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

var bombs := 1;

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
@onready var BossHealthBar: ProgressBar = $BossHealthBar


#Code that needs to run on start
func _ready() -> void:
	#This block is for dynamic creation of heartTextures that go on the UI
	#How many hearts that are created depend on currentHealth
	#Uses regex and a custom sort to sort names of each heart texture
	for i in range(currentHealth-1):
		var clone = HeartTextureRect.duplicate();
		clone.name = "HeartTexture" + str(i+1)
		HeartContainer.add_child(clone);
	heartTextures = get_tree().get_nodes_in_group("heartsGroup");
	var regex = RegEx.new()
	regex.compile("\\d+")
	heartTextures.sort_custom(func(a, b): return int(regex.search(a.name).get_string()) < int(regex.search(b.name).get_string()));
	
	#Make sure the bomb progress bar is 0 and bomb label is current
	bombPBar.value = 0;
	bombLabel.text = "x" + str(bombs);
	
	#This sets up the global signals for the script
	#Some are not in use
	GlobalSignals.connect("health_change", Callable(self, "_on_player_health_change"));
	GlobalSignals.connect("near_miss", Callable(self, "_near_Miss_Bomb"));
	GlobalSignals.connect("bomb_used", Callable(self, "_bomb_Used"));
	GlobalSignals.connect("enemy_progress", Callable(self, "_update_waveprogressbar"));
	GlobalSignals.connect("boss_health_change", Callable(self, "_on_boss_health_change"));
	GlobalSignals.connect("boss_spawned", Callable(self, "_on_boss_spawned"));
	GlobalSignals.connect("boss_died", Callable(self, "_on_boss_died"));
	
	#Remove after minion waves get put in
	#Pauses the game after a level is loaded for a few seconds
	emit_signal("bossInbound");
	
	#sets the Boss Health Bar to not visible
	BossHealthBar.visible = false

#Increases the timer every second
#If scene tree is paused or stopped flag is flipped timer doesn't increase
func _process(delta: float) -> void:
	#if testVar==false:
		#_on_player_health_change(5);
		#testVar=true
	if stopped||get_tree().paused:
		return
	time += delta;
	timeLabel.text = _time_to_String();
	
	
"""
Activated by GlobalSignals from player script
Since player health has to work in multiples of 10
because of how the flower petal animations work the new health
amount has to be divided in 2.
Uses the heartTextures array which is sorted and just changes the hearts
"""
func _on_player_health_change(new_health) -> void:
	var temp := int(new_health/2);
	if(temp >= 0 and temp <= 5):	
		if(currentHealth < temp):
			currentHealth = temp;
			for i in range(currentHealth):
				heartTextures[i].texture = full_heart;

		elif (currentHealth > temp):
			currentHealth = temp;
			heartTextures[currentHealth].texture = empty_heart;

		else:
			return

#Just converts the time var to a readable time format
func _time_to_String() -> String:
	var milisec = fmod(time, 1) * 100;
	var seconds = fmod(time, 60);
	var minutes = time/60;
	var format_S = "%02d:%02d:%02d";
	var complete_string = format_S % [minutes, seconds, milisec];
	return complete_string;
"""
Should be called on a near miss to increase bomb bar
Activated by GlobalSignals from nowhere for now
Currently the UI script would handle increases in bombs
based on near misses
When a bomb is gained will emit to signal of bomb_gained
Max bombs right now is 2
"""
func _near_Miss_Bomb() -> void:
	if(bombs<2):
		bombPBar.value += 10;
		if(bombPBar.value>=100):
			bombs += 1;
			bombLabel.text = "x" + str(bombs);
			bombPBar.value = 0;
			GlobalSignals.emit_signal("bomb_gained");

#activated by global signals
#When a bomb is used by player lower amount of bombs by 1
func _bomb_Used() -> void:
	bombs -= 1;
	bombLabel.text = "x" + str(bombs);

"""
Activated by global signals
Currently not used.
Signal is recived from either a minion that dies or player on kill
then increases the amount of progress on the bar
When bar is filled spawn the boss by emitting to global signal progress_bar_full
Then emits signal bossInbound to the script running on BossInboundText which pauses
the game while the boss text is displayed
"""
func _update_waveprogressbar(increase: int) -> void:
	if(waveProgressBar.visible):
		waveProgressBar.value += increase;
		if(waveProgressBar.volume >= 100):
			waveProgressBar.visible = false;
			waveProgressLabel.visible = false;
			GlobalSignals.emit_signal("progress_bar_full");
			emit_signal("bossInbound");

"""
Handles inputs for ui_cancel.
Does nothing except on event ui_cancel which is esc currently
Goes down the tree and checks the logic which does certain actions
With this tree escape works throughout the whole pause and options screen currently
"""
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
		
"""
Main Pause Panel Buttons
This block deals with the the buttons under mainPausePanel and its GridContainer
"""
func _on_resume_button_pressed() -> void:
	mainPausePanel.visible = false;
	stopped = false;
	get_tree().paused = false;
#Main Pause Panel Button
func _on_option_button_pressed() -> void:
	optionsPanel.visible = true;
#Main Pause Panel Button
func _on_quit_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://scenes/Title/Title.tscn")


"""
Options Panel Buttons
This block deals with the the buttons under optionsPanel and its GridContainer
"""
func _on_optionscontrol_button_pressed() -> void:
	controlsPanel.visible = true;
#Options Panel Button
func _on_optionsaudio_button_pressed() -> void:
	audioPanel.visible = true;
#Options Panel Button
func _on_optionsback_button_pressed() -> void:
	optionsPanel.visible = false;

"""
Control Panel Buttons
This block deals with the the buttons under controlsPanel and its GridContainer
"""
func _on_controls_back_button_pressed() -> void:
	controlsPanel.visible = false;

"""
Audio Panel Buttons
This block deals with the the buttons under audioPanel and its GridContainer
"""
func _on_audio_back_button_pressed() -> void:
	audioPanel.visible = false;

"""
Temp
Temp
"""
func _on_boss_health_change(current, max):
	if not BossHealthBar:
		return
	
	if not BossHealthBar.visible:
		BossHealthBar.visible = true
		BossHealthBar.max_value = max
		BossHealthBar.value = max
	
	BossHealthBar.value = current


func _on_boss_died():
	if BossHealthBar:
		BossHealthBar.visible = false
