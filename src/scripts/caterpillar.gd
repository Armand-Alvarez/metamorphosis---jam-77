class_name Caterpillar
extends CharacterBody2D


@export var speed: int = 300



func _process(delta: float) -> void:
	movement(delta)


func movement(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		move_and_collide(Vector2.RIGHT * speed * delta)
	if Input.is_action_pressed("move_left"):
		move_and_collide(Vector2.LEFT * speed * delta)
	if Input.is_action_pressed("move_up"):
		move_and_collide(Vector2.UP * speed * delta)
	if Input.is_action_pressed("move_down"):
		move_and_collide(Vector2.DOWN * speed * delta)

	if Input.is_action_just_pressed("move_right"):
		$Sprite2D.flip_h = true
	if Input.is_action_just_pressed("move_left"):
		$Sprite2D.flip_h = false
