class_name Game
extends Node2D


const mobs = {
	"black_ant": preload("res://src/scenes/enemies/mobs/black_ant.tscn")
}
@onready var leaf = preload("res://src/scenes/leaf.tscn")
@export var leaves: int = 0


func _ready() -> void:
	set_up_signal_bus_connections()
	leaves = 0


func _process(_delta: float) -> void:
	handle_input()

func set_up_signal_bus_connections() -> void:
	SignalBus.drop_leaves.connect(_on_leaves_dropped)
	SignalBus.leaf_picked_up.connect(_on_leaf_picked_up)

func handle_input() -> void:
	if Input.is_action_just_pressed("spawn_mob"):
		var random_marker = $CharacterBody2D/AIAttackPoints.get_children(true).pick_random()
		var mob = mobs.get("black_ant").instantiate()
		mob.marker = random_marker
		add_child(mob)


func _on_leaf_picked_up() -> void:
	leaves += 1
	$GUICanvasLayer/TextureProgressBar.value += 1
	$GUICanvasLayer/PanelContainer/HBoxContainer/LeavesCount.text = str(leaves)


func _on_leaves_dropped(amount: int, location: Vector2) -> void:
	for l in range(amount):
		var temp_leaf = leaf.instantiate()
		temp_leaf.position = location
		add_child(temp_leaf)


func _on_ult_progress_timer_timeout() -> void:
	$GUICanvasLayer/TextureProgressBar.value += 1
