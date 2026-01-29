extends Node

@onready var bg: AnimatedSprite2D = $Background
@onready var fg: AnimatedSprite2D = $Foreground
@onready var shadow: AnimatedSprite2D = $Shadow

@onready var health := 5:
	get(): return health
	set(value):
		if health == value: return
		health = value
		
		if fg: fg.play(str(health) + "_hp")
		if bg: bg.play(str(health) + "_hp")
		if shadow: shadow.play(str(health) + "_hp")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	# Use existing singleton
	if "player_color" in GlobalSignals:
		fg.modulate = GlobalSignals.player_color
	else:
		fg.modulate = Color(1,1,1)
		
func _process(delta: float) -> void:
	bg.rotation += delta
	fg.rotation += delta
	shadow.rotation += delta
	
func _on_color_picker_color_changed(color: Color) -> void:
	fg.modulate = color
	GlobalSignals.player_color = color
