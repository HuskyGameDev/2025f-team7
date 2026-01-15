extends State
@onready var collision = %CollisionShape2D

var player_entered : bool = false:
	set(value):
		player_entered = value

func _on_player_entered(body: Node2D) -> void:
	player_entered = true


func transition():
	if player_entered:
		get_parent().change_state("5Leaf")
