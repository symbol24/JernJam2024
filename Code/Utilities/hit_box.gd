class_name HitBox extends Area2D


@onready var parent:CharacterBody2D = get_parent() as CharacterBody2D


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(_area) -> void:
	if not _area is RadiationProjectile and _area.has_method("get_damages"):
		if parent.data != null:
			Audio.play_audio(DataManager.get_audio_file("player_hit"))
			parent.data.receive_damage(_area.get_damages())
