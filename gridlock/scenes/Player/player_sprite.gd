extends Node

const FLASH := preload("res://scenes/Player/player_sprite_flash.tscn")

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

func __spawn_flash(alpha: float) -> void:
	var flash := FLASH.instantiate()
	flash.rotation = fg.rotation
	flash.modulate.a = alpha
	add_child(flash)

func _on_near_miss() -> void:
	__spawn_flash(0.5)
func _on_bomb_gained() -> void:
	__spawn_flash(1)

func _ready():
	GlobalSignals.near_miss.connect(_on_near_miss)
	GlobalSignals.bomb_gained.connect(_on_bomb_gained)
	
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
