class_name mob
extends CharacterBody2D


@export var resource: Resource 
var marker: Marker2D
var mob_name: String
var speed: int
var damage: int
var health: int
var min_leaves_dropped: int
var max_leaves_dropped: int
var difficulty: int


func _physics_process(delta: float) -> void:
	var direction_vector = marker.position - position
	velocity = direction_vector.normalized() * speed * delta
	move_and_slide()
	if health <= 0:
		_death()
		queue_free()


func set_up() -> void:
	if resource:
		$Sprite2D.texture = resource.texture
		mob_name = resource.mob_name
		speed = resource.mob_speed
		damage = resource.mob_attack_damage
		health = resource.mob_health
		min_leaves_dropped = resource.min_leaves_dropped
		max_leaves_dropped = resource.max_leaves_dropped
		difficulty = resource.difficulty
	
#func _process(delta: float) -> void:
	#var direction_vector = marker.position - position
	#velocity = direction_vector.normalized() * speed * delta
	#move_and_slide()
	#if health <= 0:
		#_death()
		#queue_free()


func take_damage(amount: int) -> void:
	health -= amount
	$DamageIndicator.visible = true
	$DamageIndicator/VisibileTimer.start()


func _on_visibile_timer_timeout() -> void:
	$DamageIndicator.visible = false


func _death() -> void:
	SignalBus.drop_leaves.emit(randi_range(min_leaves_dropped, max_leaves_dropped), position)
	queue_free()
