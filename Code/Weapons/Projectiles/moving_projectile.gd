class_name MovingProjectile extends Projectile

@onready var attack_collider: CollisionShape2D = %attack_collider

var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= data.life_time:
			timer = 0.0
			_return_to_pool()

var direction:Vector2 = Vector2.RIGHT
var angle:Vector2 = Vector2.ZERO


func _ready() -> void:
	body_entered.connect(_body_entered)


func _physics_process(_delta: float) -> void:
	if is_active and data!= null:
		global_position += direction * data.speed * _delta
		timer += _delta


func set_projectile(_data:WeaponData, _owner:SyCharacterBody2D, _target:Enemy2D = null) -> void:
	parent = _owner
	data = _data.duplicate()
	damages = data.damages
	_set_damage_owner()
	target = _target
	global_position = _owner.global_position
	timer = 0.0
	can_hit = true
	show()
	if target != null:
		direction = global_position.direction_to(target.global_position)
		look_at(target.global_position)


func _return_to_pool() -> void:
	is_active = false
	get_parent().remove_child.call_deferred(self)
	Signals.ReturnProjectileToPool.emit(self)


func _body_entered(_body) -> void:
	if _body.is_in_group("environment") or _body.is_in_group("enemy"):
		hide()
		_return_to_pool()
