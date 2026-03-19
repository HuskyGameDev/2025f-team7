extends Area2D

const TEXTURE_RADIUS := 1024 - 64

var target_distance: float

func _ready() -> void:
	scale = Vector2.ZERO

func _physics_process(delta: float) -> void:
	scale += Vector2.ONE * delta * 16
	if scale.length() > 8: queue_free()


func _on_area_entered(area) -> void:
	area.blow_up()
