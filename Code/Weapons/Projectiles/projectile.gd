class_name Projectile extends AttackArea


@export var hit_count:int = 1:
	get:
		var result = int(data.get_level_data_for("hit_count")) if data != null else 0
		if result != 0:
			return result
		return hit_count

var data:WeaponData
var is_active:bool = false
var target:Enemy2D
var current_hit_count:int = 0
var can_hit:bool:
	get:
		return current_hit_count > 0


func set_projectile(_data:WeaponData, _owner:SyCharacterBody2D, _target = null) -> void:
	parent = _owner
	data = _data.duplicate()
	data.parse_level_data()
	scale = Vector2(data.projectile_scale, data.projectile_scale)
	damages = data.damages
	_set_damage_owner()
	current_hit_count = hit_count
	target = _target
	global_position = _owner.global_position


func shoot() -> void:
	is_active = true
	Audio.play_audio(DataManager.get_audio_file(data.audio_file_name))


func _return_to_pool() -> void:
	set_deferred("is_active", false)
	if get_parent() != null:
		get_parent().remove_child.call_deferred(self)
	Signals.ReturnProjectileToPool.emit(self)


func get_damages() -> Array[Damage]:
	_update_base_damages(damages)
	return damages


func _update_base_damages(_damages:Array[Damage]) -> void:
	var base_damage = int(data.get_level_data_for("base_damage"))
	#print("level_data base_damage for level ", data.level, ": ", base_damage)
	if base_damage > 0:
		for each in _damages:
			each.base_damage = base_damage