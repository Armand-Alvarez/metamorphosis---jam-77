class_name Game
extends Node2D


const mobs = {
	"black_ant": preload("res://src/scenes/enemies/mobs/black_ant.tscn")
}


func _ready() -> void:
	set_up_signal_bus_connections()


func _process(_delta: float) -> void:
	handle_input()


func set_up_signal_bus_connections() -> void:
	SignalBus.health_changed.connect(_on_health_changed)


func _on_health_changed(health: int) -> void:
	for heart in $Hearts.get_children():
		pass



func handle_input() -> void:
	if Input.is_action_just_pressed("spawn_mob"):
		var random_marker = $CharacterBody2D/AIAttackPoints.get_children(true).pick_random()
		var mob = mobs.get("black_ant").instantiate()
		mob.marker = random_marker
		add_child(mob)
