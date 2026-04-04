@abstract class_name BossPhase
extends Node

# once the health reaches this value, the state
# will automatically be entered!
@export var health_target_percentage: float
# the phase must last for at least this long
# (useful for animated phase transitions!
@export var minimum_time: float

func enter() -> void: pass
func exit() -> void: pass
