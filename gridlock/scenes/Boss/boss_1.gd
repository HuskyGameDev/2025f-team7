extends Boss

const SPAWNER := preload("res://scenes/basicEnemies/enemy_spawner.tscn")
const TL_TURRET := preload("res://scenes/Boss/Turrets/tl_turret.tscn")
const TR_TURRET := preload("res://scenes/Boss/Turrets/tr_turret.tscn")
const BL_TURRET := preload("res://scenes/Boss/Turrets/bl_turret.tscn")
const BR_TURRET := preload("res://scenes/Boss/Turrets/br_turret.tscn")

var theta: float = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@export var starting_pattern: int
@export var starting_movement: int
@export var bullet_node: PackedScene

@onready var finite_state_machine := $FiniteStateMachine
@onready var movement_state_machine := $MovementStateMachine

@onready var tl_turret: Node2D = null
@onready var tr_turret: Node2D = null
@onready var bl_turret: Node2D = null
@onready var br_turret: Node2D = null

@onready var phase := 0:
	get(): return phase
	set(value):
		value = clampi(value, 0, 3)
		if value == phase: return
		phase = value
		
		match phase:
			1: __spawn_turrets()
			2: pass # TODO
			3: __spawn_turrets()

@onready var health_target := max_health * 3 / 4

var bullet_type: int = 0
var speed: int = 100
var move_speed: float = 0.8
var move_size: int = 500
var t: float = 0.0
var pos: Vector2 = Vector2.ZERO

func __spawn_turrets() -> void:
	# TODO: this is terrible
	if tl_turret == null:
		tl_turret = SPAWNER.instantiate()
		tl_turret.global_position = Vector2(100, 100)
		tl_turret.spawns = TL_TURRET
		tl_turret.spawned.connect(_on_tl_turret_spawned)
		get_tree().current_scene.add_child(tl_turret)
	if tr_turret == null:
		tr_turret = SPAWNER.instantiate()
		tr_turret.global_position = Vector2(1666, 100)
		tr_turret.spawns = TR_TURRET
		tr_turret.spawned.connect(_on_tr_turret_spawned)
		get_tree().current_scene.add_child(tr_turret)
	if bl_turret == null:
		bl_turret = SPAWNER.instantiate()
		bl_turret.global_position = Vector2(100, 980)
		bl_turret.spawns = BL_TURRET
		bl_turret.spawned.connect(_on_bl_turret_spawned)
		get_tree().current_scene.add_child(bl_turret)
	if br_turret == null:
		br_turret = SPAWNER.instantiate()
		br_turret.global_position = Vector2(1666, 980)
		br_turret.spawns = BR_TURRET
		br_turret.spawned.connect(_on_br_turret_spawned)
		get_tree().current_scene.add_child(br_turret)
	
	finite_state_machine.change_state("Idle")
	movement_state_machine.change_state("Figure8")

func _on_tl_turret_spawned(turret: Node2D) -> void:
	tl_turret = turret
	turret.tree_exiting.connect(_on_tl_turret_died)
func _on_tr_turret_spawned(turret: Node2D) -> void:
	tr_turret = turret
	turret.tree_exiting.connect(_on_tr_turret_died)
func _on_bl_turret_spawned(turret: Node2D) -> void:
	bl_turret = turret
	turret.tree_exiting.connect(_on_bl_turret_died)
func _on_br_turret_spawned(turret: Node2D) -> void:
	br_turret = turret
	turret.tree_exiting.connect(_on_br_turret_died)

func _on_tl_turret_died() -> void:
	tl_turret = null
	if tr_turret == null and bl_turret == null and br_turret == null:
		__turrets_died()
func _on_tr_turret_died() -> void:
	tr_turret = null
	if tl_turret == null and bl_turret == null and br_turret == null:
		__turrets_died()
func _on_bl_turret_died() -> void:
	bl_turret = null
	if tl_turret == null and tr_turret == null and br_turret == null:
		__turrets_died()
func _on_br_turret_died() -> void:
	br_turret = null
	if tl_turret == null and tr_turret == null and bl_turret == null:
		__turrets_died()

func __turrets_died() -> void:
	finite_state_machine.change_state("PrepareBurst")
	movement_state_machine.change_state("Idle")

func get_vector(angle):
	theta = angle + alpha
	return Vector2(cos(theta),sin(theta))

func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	bullet.position = global_position
	bullet.direction = get_vector(angle)
	bullet.set_property(bullet_type)
	bullet.set_speed(speed)
	
	get_tree().current_scene.call_deferred("add_child", bullet)

func _on_speed_timeout():
	shoot(theta)

func burst(countCircle, countOut, minVel, maxVel):
	alpha = 2*PI/countCircle
	for n in countOut:
		speed = ((maxVel-minVel)/countOut)*n + minVel
		for m in countCircle:
			shoot(theta)

func trackShoot(countRows, countCols, minVel, maxVel, angle):
	alpha = angle/countCols
	for n: int in countRows:
		speed = ((maxVel-minVel)/countRows)*n + minVel
		theta = Vector2(1,0).angle_to(target - position) - (angle/2)
		#shoot(theta)
		for m in countCols:
			shoot(theta)
		
	
func _ready():
	super._ready()
	$AnimatedSprite2D.play("move")
	pos = global_position

func _on_health_changed(_new_health):
	if health < health_target:
		health_target -= max_health / 4
		phase += 1
