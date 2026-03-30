extends Node

@export var tutorial_enemy_scene: PackedScene
var spawned_enemy = null
var step = 0
var waiting_for_action = false

func _ready():
	$CanvasLayer/Panel/Label.text = "This tutorial will explain the controls. Press Enter to start!"
	waiting_for_action = false
	
func _input(event):
	if Input.is_action_just_pressed("Confirm"):
		if not waiting_for_action:
			instruction()
			
func instruction():
	match step:
		0:
			$CanvasLayer/Panel/Label.text = "Move the flower using WASD."
			waiting_for_action = true
			step += 1
		1: 
			$CanvasLayer/Panel/Label.text = "Move the saw using the arrow keys."
			waiting_for_action = true
			step += 1
		2:
			$CanvasLayer/Panel/Label.text = "The saw harms the enemies, and it is invulnerable to bullets."
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
			step += 1
		3:
			$CanvasLayer/Panel/Label.text = "Use the saw to destroy this enemy."
			waiting_for_action = true
			spawn_enemy()
			step += 1
		4:
			$CanvasLayer/Panel/Label.text = "The center of the flower is vulnerable to bullets. The amount of flower petals represents its health."
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
			step += 1
		5:
			$CanvasLayer/Panel/Label.text = "If you want to have more prescise movements, you can hold control to slow the flowers move speed. Try it!"
			waiting_for_action = true
			step += 1
		6:
			$CanvasLayer/Panel/Label.text = "If you hold shift it does the opposite and speeds up the flower. Give it a try!"
			waiting_for_action = true
			step += 1
		7:
			$CanvasLayer/Panel/Label.text = "Additionally, you have a Bomb Bar in the bottom right, it will fill up as you narrowly dodge enemy bullets"
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
			step += 1
		8:
			$CanvasLayer/Panel/Label.text = "Once the bomb bar reaches 100%, the bomb is ready. Press space to launch a bomb. Why dont you try it now."
			waiting_for_action = true
			step += 1
		9:
			$CanvasLayer/Panel/Label.text = "The tutorial is now over. Press Esc to open the pause menu, and press quit to leave the tutorial."
			step += 1

func _process(_delta):
	if step == 1 and waiting_for_action:
		if Input.get_vector("MainPlayerMoveLeft", "MainPlayerMoveRight", "MainPlayerMoveUp", "MainPlayerMoveDown") != Vector2.ZERO:
			waiting_for_action = false
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
	if step == 2 and waiting_for_action:
		if Input.get_vector("SawPlayerMoveLeft", "SawPlayerMoveRight", "SawPlayerMoveUp", "SawPlayerMoveDown") != Vector2.ZERO:
			waiting_for_action = false
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
	if step == 6 and waiting_for_action:
		if Input.is_action_just_pressed("SlowWalk"):
			waiting_for_action = false
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
	if step == 7 and waiting_for_action:
		if Input.is_action_just_pressed("FastWalk"):
			waiting_for_action = false
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
	if step == 9 and waiting_for_action:
		if Input.is_action_just_pressed("UseBomb"):
			waiting_for_action = false
			$CanvasLayer/Panel/Label.text += "\n(Press Enter to Continue)"
	
func spawn_enemy():
	if tutorial_enemy_scene == null:
		return
	
	spawned_enemy = tutorial_enemy_scene.instantiate()
	
	spawned_enemy.global_position = Vector2(1000, 400)
	
	get_tree().current_scene.add_child(spawned_enemy)
	
	spawned_enemy.connect("died", Callable(self, "_on_enemy_died"))

func _on_enemy_died():
	print("tutorial recieved enemy death")
	if step == 4 and waiting_for_action:
		waiting_for_action = false
		$CanvasLayer/Panel/Label.text += "\n(click to continue)"
