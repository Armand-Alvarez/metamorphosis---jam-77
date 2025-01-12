class_name Leaf
extends RigidBody2D


@export var speed : float = 200.0


func _process(delta: float) -> void:
	var colliding_body_array = $GravityArea.get_overlapping_bodies()
	print(colliding_body_array)
	if not colliding_body_array.is_empty():
		var body = colliding_body_array[0]
		move_and_collide((body.position - position).normalized() * delta * speed)



func _on_collection_area_body_entered(body: Node2D) -> void:
	SignalBus.leaf_picked_up.emit()
	queue_free()
