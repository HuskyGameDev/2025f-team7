extends Node2D

# If disabled, the enemy wave will remove itself
# from the scene
@export var enabled := true
# How long to wait after the wave is complete before
# starting the next item on the Timeline
@export var delay := 0.0

@onready var timer := 0.0

func _ready() -> void:
	if !enabled: queue_free()

func _process(delta: float) -> void:
	if get_child_count() != 0: return
	timer += delta
	if timer >= delay:
		queue_free()
