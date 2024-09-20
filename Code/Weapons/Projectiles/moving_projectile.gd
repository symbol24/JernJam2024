class_name MovingProjectile extends Projectile

@onready var attack_collider: CollisionShape2D = %attack_collider

var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= data.projectile_life_time:
			timer = 0.0
			_return_to_pool()

var direction:Vector2 = Vector2.RIGHT
var angle:Vector2 = Vector2.ZERO
var speed:float = 150


func _ready() -> void:
	body_entered.connect(_body_entered)


func _physics_process(_delta: float) -> void:
	if is_active and data!= null:
		global_position += direction * speed * _delta
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
	if data.extras.has("speed"): speed = data.extras["speed"]
	show()
	if target != null:
		direction = global_position.direction_to(target.global_position)
		look_at(target.global_position)


func _body_entered(_body) -> void:
	if _body.is_in_group("environment") or _body.is_in_group("enemy"):
		hide()
		_return_to_pool()
