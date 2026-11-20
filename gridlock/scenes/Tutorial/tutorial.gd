extends Node

@export var tutorial_enemy_scene: PackedScene
@export var spawner_scene: PackedScene

var spawned_enemy = null
var step = 0
var waiting_for_action = false

@onready var label: RichTextLabel = $CanvasLayer/Panel/Label

const BUTTON_ADVANCE := "[img]res://assets/sprites/ArcadeCabinet/button_advance.png[/img]"
const BUTTON_BOMB := "[img]res://assets/sprites/ArcadeCabinet/button_bomb.png[/img]"
const BUTTON_FAST := "[img]res://assets/sprites/ArcadeCabinet/button_fast.png[/img]"
const BUTTON_PAUSE := "[img]res://assets/sprites/ArcadeCabinet/button_pause.png[/img]"
const BUTTON_SLOW := "[img]res://assets/sprites/ArcadeCabinet/button_slow.png[/img]"

func _ready():
	label.clear()
	label.append_text("This tutorial will explain the controls. Press ")
	label.append_text(BUTTON_ADVANCE)
	label.append_text(" to start!")
	
	waiting_for_action = false
	
func _input(event):
	if Input.is_action_just_pressed("Confirm"):
		if not waiting_for_action:
			instruction()

func __action_complete():
	waiting_for_action = false
	label.newline()
	label.append_text("(Press ")
	label.append_text(BUTTON_ADVANCE)
	label.append_text(" to continue)")

func instruction():
	label.clear()
	waiting_for_action = true
	match step:
		0: label.append_text("Move the flower using the left joystick.")
		1: label.append_text("Move the saw using the right joystick.")
		2:
			label.append_text("The saw harms the enemies, and it is invulnerable to bullets.")
			__action_complete()
		3:
			label.append_text("Use the saw to destroy this enemy.")
			spawn_enemy()
		4:
			label.append_text("The center of the flower is vulnerable to bullets. The amount of flower petals represents its health.")
			label.newline()
			__action_complete()
		5:
			label.append_text("If you want to have more prescise movements, you can hold ")
			label.append_text(BUTTON_SLOW)
			label.append_text(" to slow the flowers move speed. Try it!")
		6:
			label.append_text("If you hold ")
			label.append_text(BUTTON_FAST)
			label.append_text(" it does the opposite and speeds up the flower. Give it a try!")
		7:
			label.append_text("Additionally, you have a Bomb Bar in the bottom right, it will fill up as you narrowly dodge enemy bullets")
			__action_complete()
		8:
			label.append_text("Once the bomb bar reaches 100%, the bomb is ready. Press ")
			label.append_text(BUTTON_BOMB)
			label.append_text(" to launch a bomb.")
			GlobalSignals.emit_signal("bomb_gained")
		9:
			label.append_text("The tutorial is now over. Press ")
			label.append_text(BUTTON_PAUSE)
			label.append_text(" to open the pause menu, and press quit to leave the tutorial.")
	step += 1

func _process(_delta):
	if step == 1 and waiting_for_action:
		if Input.get_vector("MainPlayerMoveLeft", "MainPlayerMoveRight", "MainPlayerMoveUp", "MainPlayerMoveDown") != Vector2.ZERO:
			__action_complete()
	if step == 2 and waiting_for_action:
		if Input.get_vector("SawPlayerMoveLeft", "SawPlayerMoveRight", "SawPlayerMoveUp", "SawPlayerMoveDown") != Vector2.ZERO:
			__action_complete()
	if step == 6 and waiting_for_action:
		if Input.is_action_just_pressed("SlowWalk"):
			__action_complete()
	if step == 7 and waiting_for_action:
		if Input.is_action_just_pressed("FastWalk"):
			__action_complete()
	if step == 9 and waiting_for_action:
		if Input.is_action_just_pressed("UseBomb"):
			__action_complete()
	
func spawn_enemy():
	if tutorial_enemy_scene == null:
		return
	
	var spawner = spawner_scene.instantiate()
	spawner.spawns = tutorial_enemy_scene
	spawner.spawn_time = 0.75
	spawner.scale = Vector2.ONE * 1.5
	spawner.spawned.connect(_on_enemy_spawned)
	spawner.global_position = Vector2(1000, 400)
	add_child(spawner)

func _on_enemy_spawned(enemy: Node2D) -> void:
	enemy.died.connect(_on_enemy_died)

func _on_enemy_died():
	print("tutorial recieved enemy death")
	if step == 4 and waiting_for_action:
		__action_complete()
