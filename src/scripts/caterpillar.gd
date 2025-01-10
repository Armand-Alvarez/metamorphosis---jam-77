class_name Caterpillar
extends CharacterBody2D


@export var speed: int = 300

@onready var _animation_sprite = $AnimatedSprite2D



func _process(delta: float) -> void:
	movement(delta)


func movement(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		move_and_collide(Vector2.RIGHT * speed * delta)
		_animation_sprite.play("move")
	if Input.is_action_pressed("move_left"):
		move_and_collide(Vector2.LEFT * speed * delta)
		_animation_sprite.play("move")
	if Input.is_action_pressed("move_up"):
		move_and_collide(Vector2.UP * speed * delta)
		_animation_sprite.play("move")
	if Input.is_action_pressed("move_down"):
		move_and_collide(Vector2.DOWN * speed * delta)
		_animation_sprite.play("move")
	if not Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
		_animation_sprite.play("idle")

	if Input.is_action_just_pressed("move_right"):
		$AnimatedSprite2D.flip_h = true
	if Input.is_action_just_pressed("move_left"):
		$AnimatedSprite2D.flip_h = false
