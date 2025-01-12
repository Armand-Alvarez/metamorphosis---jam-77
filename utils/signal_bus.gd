extends Node



# Character Signals
signal health_changed(health: int)


# Mob Signals
signal spawn_mob(marker: Marker2D)
signal drop_leaves(amount: int, location: Vector2)


# Game Signals
signal leaf_picked_up()
