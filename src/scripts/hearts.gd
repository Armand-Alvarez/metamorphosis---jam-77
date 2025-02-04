class_name Hearts
extends Node2D


func _ready() -> void:
	_set_up_signal_bus_connections()


func _set_up_signal_bus_connections() -> void:
	SignalBus.health_changed.connect(_on_health_changed)

func _on_health_changed(health: int) -> void:
	for child in get_children():
		child.visible = false
	if health >= 2:
		$Heart1.visible = true
	if health >= 4:
		$Heart2.visible = true
	if health >= 6:
		$Heart3.visible = true
	if health >= 8:
		$Heart4.visible = true
	if health >= 10:
		$Heart5.visible = true
	if health >= 12:
		$Heart6.visible = true
	if health >= 14:
		$Heart7.visible = true
	if health >= 16:
		$Heart8.visible = true

	match health:
		1:
			$HalfHeart1.visible = true
		3:
			$HalfHeart2.visible = true
		5:
			$HalfHeart3.visible = true
		7:
			$HalfHeart4.visible = true
		9:
			$HalfHeart5.visible = true
		11:
			$HalfHeart6.visible = true
		13:
			$HalfHeart7.visible = true
		15:
			$HalfHeart8.visible = true
