extends Area2D

@export var texture_array : Array[Texture2D]
var speed = 100
var speedChange: int = 0

var direction = Vector2.RIGHT
var bullet_type: int = 0

func _physics_process(delta):
	position += direction * speed * delta
	rotation = Vector2.UP.angle_to(direction)
	set_speed(speed + speedChange)

func _on_screen_exited():
	queue_free()

func set_property(type):
	bullet_type = type
	$Sprite2D.texture = texture_array[type]

func set_speed(s):
	speed = s

func set_speed_change(s):
	speedChange = s

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_status(bullet_type)

func blow_up():
	queue_free()
