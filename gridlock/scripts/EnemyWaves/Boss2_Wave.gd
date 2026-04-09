extends Node2D

# If disabled, removes itself from the scene
@export var enabled := true

# How long to wait after the wave is complete before
# starting the next item on the Timeline
@export var delay := 0.0

@onready var timer := 0.0
@onready var boss_alive := true
@onready var active := false
@onready var mus_main := get_tree().current_scene.get_node("Mus_Main")

func _ready() -> void:
	if !enabled: queue_free()

func _process(delta: float) -> void:
	if !active:
		GlobalSignals.boss_spawning.emit()
		active = true
		GlobalSignals.boss_died.connect(_on_boss_died)
		mus_main.set_parameter("Game State", 2)
	
	if !boss_alive:
		timer += delta
		if timer >= delay:
			queue_free()

func _on_boss_died() -> void:
	boss_alive = false
