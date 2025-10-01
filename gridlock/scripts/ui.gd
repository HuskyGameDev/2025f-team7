extends Control


var currentHealth = 6;
var heartTextures = [];

var time = 0.0;
var stopped = false;

var testVar = false;

@export var full_heart: Texture;
@export var empty_heart: Texture;
@export var timeLabel: Label;
@export var BombPBar: ProgressBar;
@export var BombLabel: Label;


func _ready() -> void:
	heartTextures = get_tree().get_nodes_in_group("heartsGroup");
	heartTextures.sort_custom(func(a, b): return a.name > b.name);

func _process(delta: float) -> void:
	#if testVar==false:
		#_on_player_health_change(5);
		#testVar=true
	if stopped:
		return
	time += delta;
	timeLabel.text = time_to_String();
	
func _on_player_health_change(new_health):
	if(new_health >= 0 and new_health <= 6):	
		if(currentHealth < new_health):
			currentHealth = new_health;
			heartTextures[currentHealth].texture = full_heart;
			
		elif (currentHealth > new_health):
			currentHealth = new_health;
			heartTextures[currentHealth].texture = empty_heart;
			
		else:
			return
func time_to_String() -> String:
	var milisec = fmod(time, 1) * 100;
	var seconds = fmod(time, 60);
	var minutes = time/60;
	var format_S = "%02d:%02d:%02d";
	var complete_string = format_S % [minutes, seconds, milisec];
	return complete_string;
	
	
	
