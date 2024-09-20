class_name Weapon extends SyAction

const WEAPON_SPAWN_AREA = [72, 252, 24, 156]

@export var weapon_data:WeaponData

@onready var room:Room = get_tree().get_first_node_in_group("room") as Room

var data:WeaponData
var projectile_instantiated:Projectile
var projectile_pool:Array[Projectile] = []
var shoot_count:int = 0
var spawned_projectile_count:int = 0
var timer_active:bool = false
var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= data.trigger_delay:
			timer = 0.0
			timer_active = false
			_shoot_one_projectile()

var shoot_timer_active:bool = false
var shoot_timer:float = 0.0:
	set(value):
		shoot_timer = value
		if shoot_timer >= data.shoot_delay:
			shoot_timer = 0.0
			shoot_timer_active = false
			_shoot_one_projectile()
		

func _ready() -> void:
	Signals.ReturnProjectileToPool.connect(_return_projectile_to_pool)
	data = weapon_data.duplicate()
	data.parse_level_data()
	projectile_instantiated = _instantiate_projectile(data.projectile_path)
	timer_active = true


func _process(_delta: float) -> void:
	if Game.active_level.active_room is CombatRoom:
		if timer_active: timer += _delta
		if shoot_timer_active: shoot_timer += _delta


func _instantiate_projectile(_path:String) -> Projectile:
	if _path:
		return load(_path).instantiate() as Projectile
	return null


func _shoot_one_projectile() -> void:
	if shoot_count < data.projectile_count:
		#print("Attempting to shoot a projectile")
		var proj:Projectile = _get_projectile()
		room.add_child(proj)
		proj.name = data.id + "_" + str(shoot_count) + "_" + str(spawned_projectile_count)
		proj.set_projectile(data, parent, _get_target())
		proj.shoot()
		shoot_count += 1
		spawned_projectile_count += 1
		shoot_timer_active = true
	else:
		shoot_count = 0
		timer_active = true


func _get_projectile() -> Projectile:
	if projectile_pool.is_empty(): return projectile_instantiated.duplicate()
	else: return projectile_pool.pop_front()


func _get_target():
	var result = null
	match data.target_type:
		WeaponData.Target_Type.CLOSEST:
			if Game.active_level.active_room.enemy_spawner.all_enemies.is_empty(): result = null
			else: result = Game.get_closest_between(parent, Game.active_level.active_room.enemy_spawner.all_enemies as Array[Node2D])
		WeaponData.Target_Type.RANDOM_IN_RANGE:
			if parent.enemies_in_range.is_empty(): result = null
			else: result = parent.enemies_in_range.pick_random()
		WeaponData.Target_Type.RANDOM_ANYWHERE:
			if Game.active_level.active_room.enemy_spawner.all_enemies.is_empty(): result = null
			else: result = Game.active_level.active_room.enemy_spawner.all_enemies.pick_random()
		WeaponData.Target_Type.CLOSEST_IN_RANGE:
			if parent.enemies_in_range.is_empty(): result = null
			else: result = Game.get_closest_between(parent, parent.enemies_in_ranges as Array[Node2D])
		WeaponData.Target_Type.RANDOM_POSITION_ON_MAP:
			result = Vector2(randi_range(WEAPON_SPAWN_AREA[0], WEAPON_SPAWN_AREA[1]), randi_range(WEAPON_SPAWN_AREA[2], WEAPON_SPAWN_AREA[3]))
		_:
			pass
	
	return result


func _return_projectile_to_pool(_projectile:Projectile) -> void:
	if _projectile.data.id == data.id:
		projectile_pool.append(_projectile)
