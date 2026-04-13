class_name DeathScreen
extends ColorRect

const TITLE := preload("res://scenes/Title/Title.tscn")
const MAX_PROGRESS := 6.0

@export_range(0.0, 1.0) var boss_progress: float
@export var time: float

@onready var child_id := -1
@onready var try_again := %TryAgain
@onready var container := $VBoxContainer
@onready var progress_marker: Control = %ProgressMarker
@onready var progress := 0

func activate() -> void:
	try_again.grab_focus()
	visible = true
	
	var i := 0
	for child in $%ProgressDisplay.get_children():
		if progress <= i:
			child.modulate = Color.BLACK
			child.modulate.a = 0.75
		i += 2

func __format_time() -> String:
	var percentage := roundi(time * 100) % 100
	var seconds := floori(time) % 60
	var minutes := floori(time / 60)
	
	return "%02d:%02d.%02d" % [minutes, seconds, percentage]

func _ready() -> void:
	modulate.a = 0
	for child in container.get_children():
		child.modulate.a = 0
	
	GlobalSignals.boss_spawned.connect(_advance_progress)
	GlobalSignals.boss_died.connect(_advance_progress)

func _advance_progress() -> void:
	progress += 1

func _process(delta: float) -> void:
	if !visible: return
	
	progress_marker.anchor_left = progress / MAX_PROGRESS
	
	var target_node: CanvasItem
	if child_id == -1:
		target_node = self
	else:
		var children := container.get_children()
		if child_id >= children.size():
			return
		target_node = children[child_id]
	
	target_node.modulate.a += delta * 10
	if target_node.modulate.a >= 1:
		target_node.modulate.a = 1
		child_id += 1
	
	%Time.text = "time: " + __format_time()

func _on_try_again() -> void:
	get_tree().reload_current_scene()

func _on_return_to_title() -> void:
	get_tree().change_scene_to_packed(TITLE)
