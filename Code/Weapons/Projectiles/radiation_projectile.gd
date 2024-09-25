class_name RadiationProjectile extends Projectile


@onready var collider:CollisionShape2D = %collider
@onready var radiation_sprite:Node2D = %radiation_sprite

var starting_radius:float
var tick_delay:float:
	get:
		if data.get_level_data_for("tick_delay"):
			return data.get_level_data_for("tick_delay")
		return 0.2
var tick_timer:float = 0.0:
	set(value):
		tick_timer = value
		if tick_timer >= tick_delay:
			tick_timer = 0.0
			_damage_tick()
var enemies_inside:Array[Enemy2D] = []


func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	starting_radius = collider.shape.radius


func _process(_delta: float) -> void:
	if is_active:
		tick_timer += _delta


func get_damages() -> Array[Damage]:
	return []


func set_projectile(_data:WeaponData, _owner:SyCharacterBody2D, _target = null) -> void:
	parent = _owner
	data = _data.duplicate()
	data.parse_level_data()
	_update_scale(data.projectile_scale)
	damages = data.damages
	_set_damage_owner()
	current_hit_count = hit_count
	target = _target
	global_position = _owner.global_position


func _damage_tick() -> void:
	#print("Damage tick triggered for %s enemies" % enemies_inside.size())
	if not enemies_inside.is_empty():
		for each in enemies_inside:
			each.data.receive_damage(damages)


func _update_scale(_value:float = 1) -> void:
	collider.shape.set_deferred("radius", starting_radius * _value)
	radiation_sprite.scale = Vector2(1,1) * _value


func _body_entered(_body) -> void:
	if _body is Enemy2D:
		enemies_inside.append(_body)


func _body_exited(_body) -> void:
	if enemies_inside.has(_body):
		enemies_inside.erase(_body)

