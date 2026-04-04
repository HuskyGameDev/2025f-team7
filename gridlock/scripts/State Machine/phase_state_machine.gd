extends Node

var current_phase_id: int
@onready var timer := 0.0

func _ready():
	var children := get_children()
	if children.size() == 0:
		current_phase_id = 0
		return
	
	current_phase_id = 1
	var current_phase := get_children()[current_phase_id]
	current_phase.enter()
	
	owner.health_changed.connect(_on_health_changed)

func _process(delta: float) -> void:
	if timer <= 0: return
	
	timer -= delta
	if timer <= 0:
		timer = 0
		__next_phase()

func _on_health_changed(health: float, max_health: float) -> void:
	var health_percent := 100 * health / max_health
	
	var children := get_children()
	if children.size() <= current_phase_id: return
	var phase: BossPhase = children[current_phase_id]
	
	while true:
		if health_percent > phase.health_target_percentage:
			return
		
		phase.exit()
		current_phase_id += 1
		
		if children.size() <= current_phase_id: return
		phase = children[current_phase_id]
		
		phase.enter()

func __next_phase() -> void:
	var health_percent: float = 100 * owner.health / owner.max_health
	
	var children := get_children()
	if children.size() <= current_phase_id: return
	var phase: BossPhase = children[current_phase_id]
	
	while true:
		if health_percent > phase.health_target_percentage:
			return
		
		phase.exit()
		current_phase_id += 1
		
		if children.size() <= current_phase_id: return
		phase = children[current_phase_id]
		
		phase.enter()
		if phase.minimum_time > 0:
			timer = phase.minimum_time
			return
