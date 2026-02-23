extends PanelContainer

@export var CreditPanel: PanelContainer

func _ready() -> void:
	CreditPanel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_credit_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	CreditPanel.visible = true
	pass # Replace with function body.


func _on_credit_back_button_pressed() -> void:
	CreditPanel.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass # Replace with function body.
