extends Area2D

@export var shape: CollisionShape2D
@export var xpos: float
@export var ypos: float
@export var timer1: float
@export var timer2: float
@export var rot: float

func _ready(): 
	$CollisionShape2D.disabled=true
	$Sprite2D.self_modulate.a=0
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "self_modulate", Color(1,1,1,0.5), 2.5)
	await tween.finished
	$Sprite2D.self_modulate.a=1
	$CollisionShape2D.disabled=false
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _on_body_entered(body):
	print("body entered")
	print(body)
	if body.is_in_group("player"):
		body.set_status(0)
