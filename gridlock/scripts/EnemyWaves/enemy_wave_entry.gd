class_name EnemyWaveEntry extends Node

# how many points to add to the wave's difffuclty total
# (a higher number will result in fewer enemies spawning to
#  adjust for your very difficult enemy, whereas a lower number
#  will allow many more enemies to spawn!)
@export var difficulty: float
# how likely this enemy is to appear (higher: more likely)
@export var weight: float
# a scene describing the enemy (the enemy will be considered
# dead when this scene's root node is removed from the scene tree!)
@export var spawns: PackedScene
