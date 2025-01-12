extends Control


var upgrade_costs = []
var upgrade_levels = {
	"health": 0,
	"attack_speed": 0,
	"attack_damage": 0,
}


func _ready() -> void:
	$MenuCanvasLayer.visible = true
	$UpgradesCanvasLayer.visible = false
	upgrade_costs = get_parent().upgrade_costs
	upgrade_levels = get_parent().upgrade_levels
	_prepare_cost_labels()



func _prepare_cost_labels() -> void:
	$UpgradesCanvasLayer/VBoxContainer/HealthHBoxContainer/Cost.text = str(upgrade_costs[upgrade_levels["health"]])
	$UpgradesCanvasLayer/VBoxContainer/AttackSpeedHBoxContainer/Cost.text = str(upgrade_costs[upgrade_levels["attack_speed"]])
	$UpgradesCanvasLayer/VBoxContainer/AttackDamageHBoxContainer/Cost.text = str(upgrade_costs[upgrade_levels["attack_damage"]])
	$UpgradesCanvasLayer/LeavesHBoxContainer/LeavesOwnedLabelLabel.text = str(get_parent().leaves_owned)


func _on_start_button_pressed() -> void:
	SignalBus.start_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	SignalBus.quit_button_pressed.emit()


func _on_health_upgrade_button_pressed() -> void:
	SignalBus.upgrade_bought.emit("health")
	_prepare_cost_labels()


func _on_attack_damage_button_pressed() -> void:
	SignalBus.upgrade_bought.emit("attack_damage")
	_prepare_cost_labels()


func _on_attack_speed_button_pressed() -> void:
	SignalBus.upgrade_bought.emit("attack_speed")
	_prepare_cost_labels()


func _on_upgrade_back_button_pressed() -> void:
	$MenuCanvasLayer.visible = true
	$UpgradesCanvasLayer.visible = false


func _on_upgrades_button_pressed() -> void:
	$MenuCanvasLayer.visible = false
	$UpgradesCanvasLayer.visible = true
