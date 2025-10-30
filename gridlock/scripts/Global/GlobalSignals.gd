extends Node

signal player_position(position: Vector2)
signal health_change(newHealth: int)#signal used to send out health changes
signal near_miss()#signal to send out when the player encounters a near miss
signal bomb_gained()#signal sent out when bomb is gained.
signal bomb_used()#signal sent out on bomb use.
signal enemy_progress(increase: int)
signal progress_bar_full()
var player_color: Color = Color(1, 1, 1)  # default white
