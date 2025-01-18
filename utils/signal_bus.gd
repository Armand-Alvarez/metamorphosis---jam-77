extends Node



# Character Signals
signal health_changed(health: int)
signal caterpillar_died()


# Mob Signals
signal spawn_mob(marker: Marker2D)
signal drop_leaves(amount: int, location: Vector2)


# Game Signals
signal leaf_picked_up()
signal butterfly_gone()


# Menu Signals
signal start_button_pressed()
signal quit_button_pressed()
signal upgrade_bought()
