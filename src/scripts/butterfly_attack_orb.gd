extends Sprite2D


@export var damage: int = 5
@export var speed: int = 100
var direction = Vector2.UP



func _process(delta: float) -> void:
	self.position += speed * direction * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(damage)


func _on_timer_timeout() -> void:
	self.queue_free()
