class_name Projectile extends AttackArea


var data:WeaponData
var is_active:bool = false
var target:Enemy2D


func set_projectile(_data:WeaponData, _owner:SyCharacterBody2D, _target:Enemy2D = null) -> void:
	parent = _owner
	data = _data.duplicate()
	damages = data.damages
	_set_damage_owner()
	target = _target
	can_hit = true
	global_position = _owner.global_position


func shoot():
	is_active = true


func _return_to_pool() -> void:
	is_active = false
	get_parent().remove_child(self)
	Signals.ReturnProjectileToPool.emit(self)


func _set_damage_owner() -> void:
	for each in damages:
		each.damage_owner = parent.data


func get_damages() -> Array[Damage]:
	if can_hit:
		can_hit = false
		return damages
	return []
