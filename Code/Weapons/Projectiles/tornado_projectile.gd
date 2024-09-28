class_name TornadoProjectile extends Projectile


@onready var collider:CollisionShape2D = $collider

var life_time_timer:float = 0.0:
	set(value):
		life_time_timer = value
		if life_time_timer >= data.projectile_life_time:
			life_time_timer = 0.0
			_return_to_pool()
var toggle_delay:float = 0.5
var toggle_timer:float = 0:
	set(value):
		toggle_timer = value
		if toggle_timer >= toggle_delay:
			toggle_timer = 0.0
			collider.disabled = !collider.disabled
var starting_pos:Vector2
var shake_strength:int = 1
var tween:Tween


func _ready() -> void:
	collider.disabled = true


func _process(_delta: float) -> void:
	if is_active:
		toggle_timer += _delta
		life_time_timer += _delta


func shoot():
	is_active = true
	#_shake()
	_move_to(parent.global_position)


func set_projectile(_data:WeaponData, _owner:SyCharacterBody2D, _target = Vector2.ZERO) -> void:
	parent = _owner
	data = _data.duplicate()
	data.parse_level_data()
	scale = Vector2(data.projectile_scale, data.projectile_scale)
	damages = data.damages
	_set_damage_owner()
	current_hit_count = hit_count
	var no_target:bool = false
	if _target != null:
		global_position = _target
		starting_pos = global_position
		if _target == Vector2.ZERO: no_target = true
	else: no_target = true
	if no_target: push_error("Projectile ", _data.id, " does not receive a proper target Vector2.")
	if data.extras.has("shake_strength"): shake_strength = data.extras["shake_strength"]
	can_hit = true
	scale = Vector2(1,1) *_data.projectile_scale



func _move_to(_pos:Vector2) -> void:
	var m_tween:Tween = self.create_tween()
	m_tween.tween_property(self, "global_position", _pos, data.projectile_life_time)


func _shake(_shake_time:float = 0.1) -> void:
	if self != null:
		tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", _get_random_shake_pos(global_position), _shake_time)
		await tween.finished
		_shake(_shake_time)


func _get_random_shake_pos(_current_pos:Vector2) -> Vector2:
	var result:Vector2 = _current_pos
	var direction:String = ["up", "down", "left", "right"].pick_random()
	match direction:
		"up":
			result -= Vector2(0, -shake_strength)
		"down":
			result -= Vector2(0, shake_strength)
		"left":
			result -= Vector2(-shake_strength, 0)
		"right":
			result -= Vector2(shake_strength, 0)

	return result


func _return_to_pool() -> void:
	if tween != null:
		tween.stop()
	set_deferred("is_active", false)
	Signals.ReturnProjectileToPool.emit(self)


func get_damages() -> Array[Damage]:
	_update_base_damages(damages)
	return damages