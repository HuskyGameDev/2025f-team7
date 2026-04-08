extends Enemy

const BULLET := preload("res://scenes/Bullet/bullet.tscn")
const SPEED := 250
const RING_SIZE := 16

# aprooximately how far offscreen the centipede needs to go
# to not be visible anymore
const MAX_DISTANCE := 1300

# TODO: hardcoded :(
const CENTER := Vector2(960, 540)

func _ready() -> void:
	super._ready()
	GlobalSignals.saw_position.connect(_track_saw)

func _track_saw(saw_pos: Vector2) -> void:
	velocity = (saw_pos - global_position).normalized() * SPEED
	rotation = velocity.angle()
	GlobalSignals.saw_position.disconnect(_track_saw)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_died():
	__bullet_ring(300, 0)
	__bullet_ring(350, PI / RING_SIZE)
	__bullet_ring(400, 0)
	__bullet_ring(450, PI / RING_SIZE)
	__bullet_ring(500, 0)

func __bullet_ring(speed: float, angle_offset: float) -> void:
	var starting_angle := get_angle_to(target) + angle_offset
	for i in range(0, RING_SIZE):
		var angle := starting_angle + i * 2 * PI / RING_SIZE
		
		var bullet := BULLET.instantiate()
		bullet.global_position = global_position
		bullet.direction = Vector2.from_angle(angle)
		bullet.set_property(0)
		bullet.set_speed_change(1)
		bullet.set_speed(speed)
		
		get_tree().current_scene.add_child(bullet)


func _on_timer_timeout():
	queue_free()
