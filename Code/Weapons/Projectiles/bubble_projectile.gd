class_name BubbleProjectile extends MovingProjectile


@onready var bubble_sprite:Node2D = %bubble_sprite
@onready var explosion:TileMapLayer = %explosion
@onready var collector_area:Area2D = %collector_area
@onready var collector_collider:CollisionShape2D = %collector_collider
@onready var wall_detector:Area2D = %wall_detector

var collected:bool = false
var prisoner:Enemy2D
var captured_timer:float = 0.0:
	set(value):
		captured_timer = value
		if captured_timer >= captured_lifetime:
			captured_timer = 0.0
			_pop()
var captured_lifetime:float = 0.0
var range_timer:float = 0.0:
	set(value):
		range_timer = value
		if range_timer >= data.projectile_life_time:
			range_timer = 0.0
			if prisoner == null:
				_pop()


func _ready() -> void:
	collector_area.body_entered.connect(_body_entered)
	wall_detector.body_entered.connect(_wall_detect)


func _physics_process(_delta: float) -> void:
	if is_active and data!= null:
		global_position += direction * speed * _delta
		range_timer += _delta
		if prisoner != null:
			captured_timer += _delta


func set_projectile(_data:WeaponData, _owner:SyCharacterBody2D, _target = null) -> void:
	super(_data, _owner, _target)
	bubble_sprite.show()
	explosion.hide()
	collector_collider.set_deferred("disabled", false)
	if data.extras.has("captured_lifetime"): captured_lifetime = data.extras["captured_lifetime"]
	if prisoner != null and prisoner.get_parent() == self: print("Why is there a prisoner: ", prisoner.name)
	prisoner = null
	captured_timer = 0.0
	range_timer = 0.0


func _pop() -> void:
	bubble_sprite.hide()
	explosion.show()
	is_active = false
	await get_tree().create_timer(0.1).timeout
	explosion.hide()
	if prisoner != null:
		prisoner.data.receive_damage(get_damages())
		prisoner.set_deferred("is_prisoner", false)
		prisoner.set_deferred("global_position", global_position)
		if prisoner.get_parent() != null and prisoner.get_parent() == self:
			remove_child(prisoner)
			if prisoner.data.current_hp > 0:
				Game.active_level.active_room.add_child.call_deferred(prisoner)
		prisoner = null
	await get_tree().create_timer(0.2).timeout
	_return_to_pool()


func _body_entered(_body) -> void:
	if prisoner == null and _body.is_in_group("enemy"):
		_body.get_parent().remove_child.call_deferred(_body)
		add_child.call_deferred(_body)
		collector_collider.disabled = true
		prisoner = _body
		prisoner.is_prisoner = true
		prisoner.position = Vector2(6,6)


func _wall_detect(_body) -> void:
	if _body.is_in_group("environment"):
		_pop()


func get_damages() -> Array[Damage]:
	_update_base_damages(damages)
	return damages
