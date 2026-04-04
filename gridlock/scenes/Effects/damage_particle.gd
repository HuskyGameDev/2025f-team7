extends AnimatedSprite2D

const GRAVITY := 200

@export var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	position += velocity * delta
	modulate.a -= delta

func _on_animation_finished() -> void:
	queue_free()
