class_name EnemySpawner extends Node2D


var level:Level
var room:Room:
	get:
		if level != null: return level.active_room
		else: 
			push_error("Level is not set in enemy spawner")
			return null

# Spawning
var spawn_active:bool = false:
	set(value):
		spawn_active = value
		if spawn_active: print("Spawn active in ", room.name)
var active_spawn_id:int = 0:
	set(_value):
		active_spawn_id = _value
		if active_spawn_id >= level.enemy_waves.size():
			active_spawn_id = 0
			spawn_active = false
			print("Spawn over")
			
var instantiated_enemies:Array[Enemy2D] = []
var enemy_pool:Array[Array] = []
var all_enemies:Array[Enemy2D] = []
var wave_count:int = 0:
	set(_value):
		wave_count = _value
		if wave_count >= level.enemy_waves[active_spawn_id].spawn_amount:
			wave_count = 0
			spawn_timer_active = false
			active_spawn_id += 1
var enemy_total_spawn_count:int = 0

# Spawn Timers
var spawn_timer_active:bool = false
var spawn_delay:float = 0.0
var spawn_timer:float = 0.0:
	set(_value):
		spawn_timer = _value
		if spawn_timer >= spawn_delay:
			spawn_timer = 0.0
			spawn_timer_active = false
			_spawn_wave(active_spawn_id)

var wait_next_spawn_timer_active:bool = false
var wait_next_spawn_delay:float = 0.0
var wait_next_spawn_timer:float = 0.0:
	set(_value):
		wait_next_spawn_timer = _value
		if wait_next_spawn_timer >= wait_next_spawn_delay:
			wait_next_spawn_timer = 0.0
			wait_next_spawn_timer_active = false
			_spawn_wave(active_spawn_id)


func _ready() -> void:
	level = get_parent() as Level
	Signals.RoomEntered.connect(_start_next_spawn_data)
	Signals.ReturnEnemyToPool.connect(_return_to_pool)
	Signals.InstantiateLevelEnemies.connect(_instantiate_enemies)


func _physics_process(_delta: float) -> void:
	if wait_next_spawn_timer_active: wait_next_spawn_timer += _delta
	if spawn_timer_active: spawn_timer += _delta


func _instantiate_enemies(_level:Level) -> void:
	# instantiting one of each enemy
	for spawn_data in _level.enemy_waves:
		for each:EnemyData in spawn_data.enemies_to_spawn:
			if _check_is_not_instantiated(each, instantiated_enemies):
				var new_enemy:Enemy2D = load(each.path).instantiate() as Enemy2D
				instantiated_enemies.append(new_enemy)


func _spawn_wave(_id:int) -> void:
	if spawn_active:
		var spawn_data:SpawnerData = level.enemy_waves[_id]
		if spawn_data != null:
			for enemy:EnemyData in spawn_data.enemies_to_spawn:
				var new_enemy = _get_instantiated_enemy(enemy, instantiated_enemies)
				room.add_child(new_enemy)
				new_enemy.name = enemy.id + str(enemy_total_spawn_count)
				new_enemy.set_data(new_enemy.name)
				new_enemy.set_level(Game.active_level.player.data.level)
				var pos:Vector2 = room.to_global(Vector2(randf_range(spawn_data.spawn_area[0], spawn_data.spawn_area[1]), randf_range(spawn_data.spawn_area[2], spawn_data.spawn_area[3])))
				new_enemy.global_position = pos
				all_enemies.append(new_enemy)
				enemy_total_spawn_count += 1
				
			spawn_delay = spawn_data.spawn_delay_between
			spawn_timer_active = true
			wave_count += 1


func _start_next_spawn_data(_room:Room.Room_Type) -> void:
	if _room == Room.Room_Type.COMBAT:
		spawn_active = true
		wait_next_spawn_delay = level.enemy_waves[active_spawn_id].delay_before_starting
		wait_next_spawn_timer_active = true


func _get_instantiated_enemy(_data:EnemyData, _list:Array[Enemy2D]) -> Enemy2D:
	for enemy in _list:
		if enemy.enemy_data.id == _data.id:
			return enemy.duplicate()
	return null


func _check_is_not_instantiated(_data:EnemyData, _list:Array[Enemy2D]) -> bool:
	for each in enemy_pool:
		if not each.is_empty() and each[0].data.id == _data.id:
			return each.pop_front()

	for each in _list:
		if each.data == _data:
			return false
		elif each.enemy_data == _data:
			return false
	return true


func _remove_enemy_from_all(_enemy:Enemy2D) -> void:
	#print("in _remove_enemy_from_all, receiving enemy: ", _enemy.name)
	all_enemies.erase(_enemy)
	print("not spawn_active: ", not spawn_active, " and all_enemies.is_empty(): ", all_enemies.is_empty())
	if not spawn_active and all_enemies.is_empty():
		Signals.RoomClear.emit()


var count:int = 0
func _return_to_pool(_enemy:Enemy2D) -> void:
	#print("in _return_to_pool, receing: ", _enemy.name, " with count: ", count)
	count += 1
	var in_pool:bool = false
	for each in enemy_pool:
		if not each.is_empty() and each[0].data.id == _enemy.data.id:
			each.append(_enemy)
			in_pool = true
			break
	
	if not in_pool:
		enemy_pool.append([_enemy])

	_remove_enemy_from_all(_enemy)
