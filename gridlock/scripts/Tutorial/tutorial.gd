extends Node

var step = 0

func _ready():
	$CanvasLayer/Panel/Label.text = "This tutorial will explain the controls. Click your mouse to continue."
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			instruction()
			
func instruction():
	match step:
		0:
			$CanvasLayer/Panel/Label.text = "Move the flower using WASD."
			step += 1
		1: 
			$CanvasLayer/Panel/Label.text = "Move the saw using the arrow keys."
			step += 1
		2:
			$CanvasLayer/Panel/Label.text = "The saw harms the enemies, and it is invulnerable to bullets."
			step += 1
		3:
			$CanvasLayer/Panel/Label.text = "The center of the flower is vulnerable to bullets. The amount of flower petals represents its health."
			step += 1
		4:
			$CanvasLayer/Panel/Label.text = "Once the bomb bar reaches 100%, the bomb is ready. Press space to launch a bomb."
			step += 1
		5:
			$CanvasLayer/Panel/Label.text = "The tutorial is now over. Press Esc to exit the tutorial."
			step += 1
