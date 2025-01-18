class_name Game
extends Node


const mobs = {
	"black_ant": preload("res://src/scenes/enemies/mobs/black_ant.tscn"),
	"red_ant": preload("res://src/scenes/enemies/mobs/red_ant.tscn"),
}
@onready var leaf = preload("res://src/scenes/leaf.tscn")
@onready var butterfly = preload("res://src/scenes/butterfly.tscn")
@export var leaves: int = 0

var can_ult: bool = false
var ult_max: int = 40
var ult_prog: int = 0
var char_to_look_at: Node2D
var difficulty: int = 0
var can_spawn = [mobs["black_ant"]]


func _ready() -> void:
	_set_up_signal_bus_connections()
	leaves = 0
	ult_max = 40
	char_to_look_at = $Caterpillar


func _process(_delta: float) -> void:
	_handle_input()
	if ult_prog >= ult_max and get_node_or_null("./Butterfly") == null:
		can_ult = true
	$Camera2D.set_position(char_to_look_at.position)


func _set_up_signal_bus_connections() -> void:
	SignalBus.drop_leaves.connect(_on_leaves_dropped)
	SignalBus.leaf_picked_up.connect(_on_leaf_picked_up)
	SignalBus.butterfly_gone.connect(_on_butterfly_gone)


func _on_leaf_picked_up() -> void:
	leaves += 1
	for child in $GUICanvasLayer/UltProgress.get_children():
		child.value += 1
	$GUICanvasLayer/PanelContainer/HBoxContainer/LeavesCount.text = str(leaves)
	ult_prog += 1


func _on_leaves_dropped(amount: int, location: Vector2) -> void:
	for l in range(amount):
		var temp_leaf = leaf.instantiate()
		temp_leaf.position = location
		add_child(temp_leaf)


func _on_ult_progress_timer_timeout() -> void:
	for child in $GUICanvasLayer/UltProgress.get_children():
		child.value += 1
	ult_prog += 1


func _handle_input() -> void:
	if Input.is_action_just_pressed("spawn_mob"):
		var random_marker = $Caterpillar/AIAttackPoints.get_children(true).pick_random()
		var m = mobs.get("black_ant").instantiate()
		m.marker = random_marker
		$Enemies.add_child(m)
	if Input.is_action_just_pressed("ultimate"):
		use_ult()


func use_ult() -> void:
	if can_ult:
		can_ult = false
		var b = butterfly.instantiate()
		SignalBus.health_changed.emit(b.health)

		b.position = $Caterpillar.position
		for enemy in $Enemies.get_children(false):
			var random_marker = b.find_child("AIAttackPoints").get_children(true).pick_random()
			enemy.marker = random_marker
		enable_disable_caterpillar()
		add_child(b)
		char_to_look_at = $Butterfly




func _on_butterfly_gone(position: Vector2) -> void:
	$Caterpillar.position = $Butterfly.position
	$Butterfly.queue_free()
	#$Caterpillar/Camera2D.make_current()
	#$Caterpillar/Camera2D.reset_smoothing()
	enable_disable_caterpillar()
	char_to_look_at = $Caterpillar

	for enemy in $Enemies.get_children(false):
		var random_marker = $Caterpillar/AIAttackPoints.get_children(true).pick_random()
		enemy.marker = random_marker

	SignalBus.health_changed.emit($Caterpillar.health)
	ult_prog = 0
	for child in $GUICanvasLayer/UltProgress.get_children(true):
		child.value = 0


func enable_disable_caterpillar() -> void:
	$Caterpillar/Hitbox.monitoring = !$Caterpillar/Hitbox.monitoring
	$Caterpillar.visible = !$Caterpillar.visible
	$Caterpillar.set_process(!$Caterpillar.is_processing())


func _on_spawn_timer_timeout() -> void:
	var max_can_spawn = 1 + difficulty*2
	for i in range(randi_range(0, max_can_spawn)):
		var to_spawn = can_spawn.pick_random().instantiate()
		var rand_angle = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
		to_spawn.position = $Camera2D.position + (rand_angle * 1000)
		var rand_marker
		if $Butterfly:
			rand_marker = $Butterfly/AIAttackPoints.get_children().pick_random()
		else:
			rand_marker = $Caterpillar/AIAttackPoints.get_children().pick_random()
		to_spawn.marker = rand_marker
		$Enemies.add_child(to_spawn)


func _on_difficulty_timer_timeout() -> void:
	difficulty += 1
	can_spawn = []
	for type in mobs.values():
		if type.instantiate().resource.difficulty <= difficulty:
			can_spawn.append(type)
