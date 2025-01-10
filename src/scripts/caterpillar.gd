class_name Caterpillar
extends CharacterBody2D


@export var speed: int = 300

@onready var _animation_sprite = $AnimatedSprite2D



func _ready() -> void:
	$NormalCollisionPolygon2D.disabled = false
	$AttackCollisionShape2D.disabled = true


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

	if Input.is_action_just_pressed("attack"):
		var mouse_position = get_viewport().get_mouse_position()
		var direction_vector = (mouse_position - position).normalized()
		var angle_of_attack = direction_vector.angle() + (PI / 2)
		_animation_sprite.rotation = angle_of_attack
		_animation_sprite.play("attack")
