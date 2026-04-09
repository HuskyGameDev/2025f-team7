class_name Boss extends Enemy

func _init() -> void:
	super._init()
	health_changed.connect(_boss_on_health_changed)
	died.connect(_boss_on_death)

func _process(delta: float) -> void:
	super._process(delta)

func _boss_on_health_changed(_value: float) -> void:
	GlobalSignals.boss_health_change.emit(health, max_health)

func _boss_on_death() -> void:
	GlobalSignals.boss_died.emit()
	get_tree().call_group("game", "on_victory")
