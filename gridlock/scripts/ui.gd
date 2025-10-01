extends Control


var currentHealth = 6;
var heartTextures = [];

var bombs = 0;

var time = 0.0;
var stopped = false;

var testVar = false;

@export var full_heart: Texture;
@export var empty_heart: Texture;
@export var timeLabel: Label;
@export var bombPBar: ProgressBar;
@export var bombLabel: Label;


func _ready() -> void:
	heartTextures = get_tree().get_nodes_in_group("heartsGroup");
	heartTextures.sort_custom(func(a, b): return a.name > b.name);
	bombPBar.value = 0;

func _process(delta: float) -> void:
	#if testVar==false:
		#_on_player_health_change(5);
		#testVar=true
	if stopped:
		return
	time += delta;
	timeLabel.text = _time_to_String();

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
	
func _near_Miss_Bomb() -> void:
	if(bombs<2):
		bombPBar.value += 10;
		if(bombPBar.volume>=100):
			bombs += 1;
			bombLabel.text = "x" + str(bombs);
			bombPBar.value = 0;
	
	
	
	
