extends Node

signal player_position(position: Vector2)
signal health_change(newHealth: int)#signal used to send out health changes
signal near_miss()#signal to send out when the player encounters a near miss
signal bomb_gained()#signal sent out when bomb is gained.
signal bomb_used()#signal sent out on bomb use.
