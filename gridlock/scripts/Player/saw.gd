extends CharacterBody2D

const PARTICLE := preload("res://scenes/Effects/damage_particle.tscn")

const SPEED = 350.0

@onready var blade_area: Area2D = $BladeArea2D
@onready var sprite: SawSprite = $SawSprite
@onready var died := false

func _ready() -> void:
	GlobalSignals.health_change.connect(_health_change)

func _physics_process(_delta: float) -> void:
	if died:
		sprite.state = SawSprite.State.PLAYER_DIED
		return
	
	var directionx := Input.get_axis("SawPlayerMoveLeft", "SawPlayerMoveRight")
	var directiony :=Input.get_axis("SawPlayerMoveUp", "SawPlayerMoveDown")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
	if blade_area.has_overlapping_areas():
		sprite.state = SawSprite.State.DEALING_DAMAGE
	else:
		sprite.state = SawSprite.State.DEFAULT
	
	for area in blade_area.get_overlapping_areas():
		var enemy: Enemy = area.get_parent()
		
		var particle := PARTICLE.instantiate()
		
		var towards_enemy := global_position.direction_to(area.global_position)

		var dir := Vector2.from_angle(randf_range(0, PI * 2))
		var strength := dir.dot(towards_enemy)
		
		particle.velocity = dir * 120
		particle.modulate = enemy.effect_color
		particle.modulate.a = strength - 0.1
		add_sibling(particle)
		particle.global_position = global_position + dir * 30
	
	GlobalSignals.saw_position.emit(global_position)

func _health_change(health: int) -> void:
	if health > 0: return
	
	died = true
	# not sure what's going on here, but these need to be
	# deferred
	$CharacterShape.set_deferred("disabled", true)
	%AreaShape.set_deferred("disabled", true)
