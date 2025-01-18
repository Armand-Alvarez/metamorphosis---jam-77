class_name Butterfly
extends CharacterBody2D

@export_category("Movement")
@export var speed: int = 600

@export_category("Attributes")
@export var health: int = 12
@export var damage: int = 5
@export var attack_speed: float = 1
@export var existence_time: int = 15

@onready var _projectile = preload("res://src/scenes/butterfly_attack_orb.tscn")

var can_take_damage: bool = true




func _ready() -> void:
	$AttackTimer.wait_time = attack_speed
	$HitIndicator.visible = false
	$ExistenceTimer.start(existence_time)
	$AIAttackPoints/Marker2D.position = position + Vector2(-11.1, -4.8)
	$AIAttackPoints/Marker2D2.position = position + Vector2(-7.3, 2.4)
	$AIAttackPoints/Marker2D3.position = position + Vector2(3.8, 4.7)
	$AIAttackPoints/Marker2D4.position = position + Vector2(10.7, -0.1)



func _process(delta: float) -> void:
	_handle_input(delta)
	var bodies_in_hitbox = $Hitbox.get_overlapping_bodies()
	if not bodies_in_hitbox.is_empty():
		var damage_taken = 0
		for body in bodies_in_hitbox:
			damage_taken += body.damage
		take_damage(damage_taken)


func _handle_input(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		move_and_collide(Vector2.RIGHT * speed * delta)
	if Input.is_action_pressed("move_left"):
		move_and_collide(Vector2.LEFT * speed * delta)
	if Input.is_action_pressed("move_up"):
		move_and_collide(Vector2.UP * speed * delta)
	if Input.is_action_pressed("move_down"):
		move_and_collide(Vector2.DOWN * speed * delta)


func attack() -> void:
	$AttackTimer.start(attack_speed)
	var projectile_directions = [
		Vector2.UP,
		Vector2.RIGHT,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2(1,1).normalized(),
		Vector2(1,-1).normalized(),
		Vector2(-1,1).normalized(),
		Vector2(-1,-1).normalized()
	]
	for dir in projectile_directions:
		var p = _projectile.instantiate()
		p.position = Vector2.ZERO + dir * 50
		p.direction = dir
		$Projectiles.add_child(p)


func _change_health(amount: int) -> void:
	health += amount
	SignalBus.health_changed.emit(health)
	if health <= 0:
		SignalBus.caterpillar_died.emit()


func _on_marker_update_timer_timeout() -> void:
	$AIAttackPoints/Marker2D.position = position + Vector2(-11.1, -4.8)
	$AIAttackPoints/Marker2D2.position = position + Vector2(-7.3, 2.4)
	$AIAttackPoints/Marker2D3.position = position + Vector2(3.8, 4.7)
	$AIAttackPoints/Marker2D4.position = position + Vector2(10.7, -0.1)


func _on_attack_timer_timeout() -> void:
	attack()


func take_damage(amount) -> void:
	if can_take_damage:
		_change_health(-amount)

		$HitIndicator.visible = true
		can_take_damage = false
		$HitIndicator/HitIndicatorTimer.start()


func _on_hit_indicator_timer_timeout() -> void:
	$HitIndicator.visible = false
	can_take_damage = true


func _on_existence_timer_timeout() -> void:
	SignalBus.butterfly_gone.emit(self.position)
