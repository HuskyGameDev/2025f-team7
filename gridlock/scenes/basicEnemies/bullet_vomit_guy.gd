extends Enemy

@export var bullet_node: PackedScene

@onready var player_position := Vector2.ZERO
@onready var anim_timer := 0.0

const BULLET_SPEED := 150
const RING_SIZE := 12
const RING_ANGLE_DRIFT := 5

func _ready() -> void:
	super._ready()
	GlobalSignals.player_position.connect(_player_position)

func _player_position(pos: Vector2):
	player_position = pos

func _process(delta: float) -> void:
	super._process(delta)
	anim_timer += 2 * PI * delta / 6
	
	position += 5 * Vector2(
		cos(anim_timer),
		sin(1.667 * anim_timer)
	) * delta

func _on_timeout():
	var starting_angle := get_angle_to(player_position)
	for i in range(0, RING_SIZE):
		var angle := starting_angle + i * 2 * PI / RING_SIZE
		
		var bullet := bullet_node.instantiate()
		bullet.global_position = global_position
		bullet.direction = Vector2.from_angle(angle)
		bullet.set_property(0)
		bullet.set_speed(BULLET_SPEED)
		
		get_tree().current_scene.add_child(bullet)
