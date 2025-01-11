class_name BlackAnt
extends CharacterBody2D


@export var resource: Resource = load("res://src/resources/enemies/mobs/black_ant.tres")
var marker: Marker2D
var mob_name: String
var speed: int
var damage: int
var health: int


func _ready() -> void:
	if resource:
		$Sprite2D.texture = resource.texture
		mob_name = resource.mob_name
		speed = resource.mob_speed
		damage = resource.mob_attack_damage
		health = resource.mob_health



func _process(delta: float) -> void:
	var direction_vector = marker.position - position
	move_and_collide(direction_vector.normalized() * speed * delta)
	if health <= 0:
		queue_free()


func take_damage(amount: int) -> void:
	health -= amount
	$DamageIndicator.visible = true
	$DamageIndicator/VisibileTimer.start()


func _on_visibile_timer_timeout() -> void:
	$DamageIndicator.visible = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
