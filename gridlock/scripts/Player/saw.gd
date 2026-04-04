extends CharacterBody2D

const PARTICLE := preload("res://scenes/Effects/damage_particle.tscn")

const SPEED = 350.0

@onready var blade_area: Area2D = $BladeArea2D
@onready var sprite := $SawSprite

func _physics_process(delta: float) -> void:
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
	
	sprite.dealing_damage = blade_area.has_overlapping_areas()
	
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
