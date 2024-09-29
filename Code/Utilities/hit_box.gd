class_name HitBox extends Area2D


@onready var parent:CharacterBody2D = get_parent() as CharacterBody2D

var can_be_hit:bool = true
var hit_timer:float = 0.1


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(_area) -> void:
	if not _area is RadiationProjectile and _area.has_method("get_damages"):
		if parent.data != null and can_be_hit:
			Audio.play_audio(DataManager.get_audio_file("player_hit"))
			parent.data.receive_damage(_area.get_damages())
			can_be_hit = false
			get_tree().create_timer(hit_timer).timeout.connect(_reset_hit)


func _reset_hit() -> void:
	can_be_hit = true