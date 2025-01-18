extends Node

const states = {
	"Menu": preload("res://src/scenes/menu.tscn"),
	"Game": preload("res://src/scenes/game.tscn"),
}


#const upgrade_costs = [10, 50, 100, 400, 1000, "Max Level!",]
const upgrade_costs = [1, 2, 3, 4, 5, "Max Level!",]
const max_upgrade_level = 5
var upgrade_levels = {
	"health": 0,
	"attack_speed": 0,
	"attack_damage": 0,
}

@export var leaves_owned: int = 0


func _ready() -> void:
	_set_up_signal_bus_connections()
	_switch_states("Menu")


func _switch_states(state_to_load: String) -> void:
	for n in get_children():
		if n.name != "Parallax2D": n.queue_free()
	var scene_to_load = states[state_to_load].instantiate()
	add_child(scene_to_load)


func _set_up_signal_bus_connections() -> void:
	SignalBus.start_button_pressed.connect(_on_start_button_pressed)
	SignalBus.quit_button_pressed.connect(_on_quit_button_pressed)
	SignalBus.upgrade_bought.connect(_on_upgrade_bought)
	SignalBus.caterpillar_died.connect(_on_caterpillar_died)
	SignalBus.leaf_picked_up.connect(_on_leaf_picked_up)


func _on_start_button_pressed() -> void:
	_switch_states("Game")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_upgrade_bought(upgrade: String) -> void:
	var current_level = upgrade_levels[upgrade]
	var current_cost = upgrade_costs[current_level]
	if current_level < max_upgrade_level:
		if leaves_owned >= current_cost:
			upgrade_levels[upgrade] += 1
			leaves_owned -= current_cost


func _on_caterpillar_died() -> void:
	_switch_states("Menu")


func _on_leaf_picked_up() -> void:
	leaves_owned += 1
