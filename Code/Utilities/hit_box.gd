class_name HitBox extends Area2D


@onready var parent:CharacterBody2D = get_parent() as CharacterBody2D


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(_area) -> void:
	if _area.has_method("get_damages"):
		if parent.data != null:
			parent.data.receive_damage(_area.get_damages())
