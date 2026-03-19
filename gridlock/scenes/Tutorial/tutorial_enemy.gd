extends Area2D

signal died

@export var health: float = 10
var beingHit: bool = false

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

func _on_player_detection_area_entered(area: Area2D):
	if (area.name == "BladeArea2D"):
		beingHit = true

func _on_area_entered(area: Area2D):
	if area.name == "BladeArea2D":
		beingHit = true

func _on_area_exited(area: Area2D):
	if area.name == "BladeArea2D":
		beingHit = false

func _process(delta):
	if beingHit:
		health -= 10 * delta
		
		if health <= 0:
			die()

func die():
	emit_signal("died")
	queue_free()
