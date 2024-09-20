class_name AttackArea extends Area2D

@export var is_contact_attack:bool = false
@export var damages:Array[Damage]

var parent:CharacterBody2D
var can_hit:bool = true


func set_contact_damages() -> void:
	if is_contact_attack: 
		parent = get_parent() as CharacterBody2D
		damages = parent.data.contact_damages


func get_damages() -> Array[Damage]:
	return damages


func _set_damage_owner() -> void:
	for each in damages:
		each.damage_owner = parent.data