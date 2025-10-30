# Player_Sprite.gd
extends Sprite2D

@export_range(0, 720, 10)
var spin_speed: float = 180.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	# Use existing singleton
	if "player_color" in GlobalSignals:
		modulate = GlobalSignals.player_color
	else:
		modulate = Color(1,1,1)
		
func _process(delta: float) -> void:
# make it spin
	rotation_degrees += spin_speed * delta
	
func _on_color_picker_color_changed(color: Color) -> void:
	modulate = color
	GlobalSignals.player_color = color
