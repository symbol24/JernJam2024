class_name Projectile extends AttackArea


var data:WeaponData
var is_active:bool = false
var target:Enemy2D


func set_projectile(_data:WeaponData, _owner:SyCharacterBody2D, _target = null) -> void:
	parent = _owner
	data = _data.duplicate()
	damages = data.damages
	_set_damage_owner()
	if target != null and target is Enemy2D:
		target = _target
	can_hit = true
	global_position = _owner.global_position


func shoot():
	is_active = true


func _return_to_pool() -> void:
	set_deferred("is_active", false)
	get_parent().remove_child.call_deferred(self)
	Signals.ReturnProjectileToPool.emit(self)


func get_damages() -> Array[Damage]:
	if can_hit:
		can_hit = false
		return damages
	return []
