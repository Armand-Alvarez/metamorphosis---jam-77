class_name Caterpillar
extends CharacterBody2D

@export_category("Movement")
@export var speed: int = 300

@export_category("Attributes")
@export var health: int = 6
@export var damage: int = 2
@export var attack_speed: float = 2.0

@onready var _animation_sprite = $AnimatedSprite2D
@onready var _attack_animation_sprite = $AnimatedAttack
@onready var _attack_timer = $AttackTimer

var can_attack: bool = true
var can_take_damage: bool = true


func _ready() -> void:
	$NormalCollisionPolygon2D.disabled = false
	$AttackCollisionShape2D.disabled = true
	_attack_timer.wait_time = attack_speed
	$HitIndicator.visible = false



func _process(delta: float) -> void:
	handle_input(delta)
	handle_animations()


func handle_input(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		move_and_collide(Vector2.RIGHT * speed * delta)
	if Input.is_action_pressed("move_left"):
		move_and_collide(Vector2.LEFT * speed * delta)
	if Input.is_action_pressed("move_up"):
		move_and_collide(Vector2.UP * speed * delta)
	if Input.is_action_pressed("move_down"):
		move_and_collide(Vector2.DOWN * speed * delta)
	if Input.is_action_pressed("attack") and can_attack:
		can_attack = false
		attack()


func handle_animations() -> void:
	var playing = _animation_sprite.animation
	if _animation_sprite.is_playing() == false:
		playing = ""
		_animation_sprite.rotation = 0
	if Input.is_action_pressed("move_right") and playing != "attack":
		_animation_sprite.play("move")
	if Input.is_action_pressed("move_left") and playing != "attack":
		_animation_sprite.play("move")
	if Input.is_action_pressed("move_up") and playing != "attack":
		_animation_sprite.play("move")
	if Input.is_action_pressed("move_down") and playing != "attack":
		_animation_sprite.play("move")
	if not Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down") and playing != "attack":
		_animation_sprite.play("idle")

	if Input.is_action_just_pressed("move_right"):
		_animation_sprite.flip_h = true
		$NormalCollisionPolygon2D.scale.x = -1
	if Input.is_action_just_pressed("move_left"):
		_animation_sprite.flip_h = false
		$NormalCollisionPolygon2D.scale.x = 1



func attack() -> void:
	_attack_timer.start(attack_speed)
	#var mouse_position = get_viewport().get_mouse_position()
	var mouse_position = get_local_mouse_position()
	var direction_vector = (mouse_position - $Camera2D.position).normalized()
	$AttackArea.position = Vector2.ZERO + (direction_vector * 2)
	$AttackArea.rotation = direction_vector.angle() + (PI / 2)
	$AttackArea.monitoring = true
	attack_animations(direction_vector)


func attack_animations(direction_vector) -> void:
	if _animation_sprite.animation != "attack":
		var angle_of_attack = direction_vector.angle() + (PI / 2)
		_animation_sprite.rotation = angle_of_attack
		_animation_sprite.play("attack")

		_attack_animation_sprite.position = Vector2.ZERO
		_attack_animation_sprite.position += (direction_vector * 20)
		_attack_animation_sprite.rotation = direction_vector.angle() + (PI/2)
		_attack_animation_sprite.visible = true
		_attack_animation_sprite.play()



func _change_health(amount: int) -> void:
	health += amount
	SignalBus.health_changed.emit(health)


func _on_marker_update_timer_timeout() -> void:
	$AIAttackPoints/Marker2D.position = position + Vector2(-11.1, -4.8)
	$AIAttackPoints/Marker2D2.position = position + Vector2(-7.3, 2.4)
	$AIAttackPoints/Marker2D3.position = position + Vector2(3.8, 4.7)
	$AIAttackPoints/Marker2D4.position = position + Vector2(10.7, -0.1)


func _on_animated_attack_animation_finished() -> void:
	_attack_animation_sprite.visible = false
	$AttackArea.monitoring = false


func _on_attack_timer_timeout() -> void:
	can_attack = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	body.take_damage(damage)


func take_damage(amount) -> void:
	if can_take_damage:
		_change_health(-amount)

		$HitIndicator.visible = true
		can_take_damage = false
		$HitIndicator/HitIndicatorTimer.start()


func _on_hit_indicator_timer_timeout() -> void:
	$HitIndicator.visible = false
	can_take_damage = true
