class_name Mobs
extends Resource


@export_category("Attributes")
@export var mob_name: String = "Mob Name"
@export var mob_health: int = 10
@export var mob_attack_damage: int = 2
@export var mob_speed: int = 100

@export_category("Art")
@export var texture: Texture2D
@export var damage_indicator: Texture2D
