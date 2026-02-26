extends Node

@onready var bg: AnimatedSprite2D = $Background
@onready var fg: AnimatedSprite2D = $Foreground
@onready var shadow: AnimatedSprite2D = $Shadow

@onready var config = ConfigFile.new() #creates configfile object
@onready var invincible := false:
	get(): return invincible
	set(value):
		if value == invincible: return
		invincible = value
		
		if invincible:
			fg.modulate.a = 0.5
		else:
			fg.modulate.a = 1

@onready var health := 5:
	get(): return health
	set(value):
		if health == value: return
		health = value
		
		if fg: fg.play(str(health) + "_hp")
		if bg: bg.play(str(health) + "_hp")
		if shadow: shadow.play(str(health) + "_hp")

func _ready():
	var err = config.load("res://save_data.cfg")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	# Use existing singleton
	if err != OK:
		fg.modulate = Color(1,1,1)
		config.set_value("Player","player_color",Color(1,1,1))
		config.save("res://save_data.cfg")
	else:
		fg.modulate = config.get_value("Player","player_color")
		
func _process(delta: float) -> void:
	bg.rotation += delta
	fg.rotation += delta
	shadow.rotation += delta
	
func _on_color_picker_color_changed(color: Color) -> void:
	fg.modulate = color
	GlobalSignals.player_color = color
	config.set_value("Player","player_color",color)
	config.save("res://save_data.cfg")
