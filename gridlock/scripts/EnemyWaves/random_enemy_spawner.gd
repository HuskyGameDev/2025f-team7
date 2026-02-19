extends Node

const ENEMY_SPAWNER := preload("res://scenes/basicEnemies/enemy_spawner.tscn")

@export var total_difficulty: float
@export var spawn_rate: float

@onready var remaining_difficulty := total_difficulty
@onready var enemies_alive := 0

@onready var timer := spawn_rate

func _process(delta: float) -> void:
	if remaining_difficulty == 0: return
	
	timer -= delta
	while timer < 0:
		__try_spawn()
		timer += spawn_rate

func __try_spawn() -> void:
	var spawnable_enemies: Array[EnemyWaveEntry] = []
	
	var total_weight := 0.0
	for child: EnemyWaveEntry in get_children():
		total_weight += child.weight
		if child.difficulty <= remaining_difficulty:
			spawnable_enemies.append(child)
	
	if spawnable_enemies.size() == 0:
		remaining_difficulty = 0
		return
	
	var roll := randf_range(0, total_weight)
	for enemy in spawnable_enemies:
		roll -= enemy.weight
		if roll > 0: continue
		
		remaining_difficulty -= enemy.difficulty
		var spawner := ENEMY_SPAWNER.instantiate()
		spawner.spawns = enemy.spawns
		spawner.spawn_time = spawn_rate
		spawner.spawned.connect(_enemy_spawned)
		get_parent().add_child(spawner)
		
		spawner.global_position = Vector2(
			randf_range(0, 1920),
			randf_range(0, 1080)
		)
		
		return

func _enemy_spawned(node: Node2D) -> void:
	enemies_alive += 1
	node.tree_exited.connect(_enemy_died)

func _enemy_died() -> void:
	enemies_alive -= 1
	if remaining_difficulty == 0 and enemies_alive == 0:
		queue_free()
