class_name EnemySpawner extends Node2D

const SPAWN_AREA = [72, 252, 24, 156]
const DISTANCE_MIN:float = 1000

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
		#if spawn_active: print("Spawner ", name," active in ", room.name)
var active_spawn_id:int = 0:
	set(_value):
		active_spawn_id = _value
		if active_spawn_id >= _get_amount_of_waves():
			active_spawn_id = 0
			spawn_active = false
			print("Spawn over")
		else:
			_start_next_spawn_data(room.room_type)

var instantiated_enemies:Array[Enemy2D] = []
var enemy_pool:Array[Array] = []
var all_enemies:Array[Enemy2D] = []
var wave_count:int = 0:
	set(_value):
		wave_count = _value
		if wave_count >= level.data.enemy_waves[active_spawn_id].spawn_amount:
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

var room_count:int = 0


func _ready() -> void:
	level = get_parent() as Level
	Signals.RestCharacter.connect(_clear_spawner)
	Signals.RoomEntered.connect(_start_next_spawn_data)
	Signals.ReturnEnemyToPool.connect(_return_to_pool)
	Signals.InstantiateLevelEnemies.connect(_instantiate_enemies)


func _process(_delta: float) -> void:
	if wait_next_spawn_timer_active: wait_next_spawn_timer += _delta
	if spawn_timer_active: spawn_timer += _delta


func _instantiate_enemies(_level:Level) -> void:
	# instantiting one of each enemy
	for spawn_data in _level.data.enemy_waves:
		for each:EnemyData in spawn_data.enemies_to_spawn:
			if _check_is_not_instantiated(each, instantiated_enemies):
				var new_enemy:Enemy2D = load(each.path).instantiate() as Enemy2D
				instantiated_enemies.append(new_enemy)


func _spawn_wave(_id:int) -> void:
	if spawn_active:
		var spawn_data:SpawnerData = level.data.enemy_waves[_id]
		if spawn_data != null:
			for enemy:EnemyData in spawn_data.enemies_to_spawn:
				var new_enemy = _get_instantiated_enemy(enemy, instantiated_enemies)
				room.add_child(new_enemy)
				new_enemy.name = enemy.id + str(enemy_total_spawn_count)
				new_enemy.set_data(new_enemy.name)
				new_enemy.set_level(_get_enemy_level())
				var pos:Vector2 = _get_spawn_point(room, Game.player)
				new_enemy.position = pos
				all_enemies.append(new_enemy)
				enemy_total_spawn_count += 1
				
			spawn_delay = spawn_data.spawn_delay_between
			spawn_timer_active = true
			wave_count += 1


func _start_next_spawn_data(_room:Room.Room_Type) -> void:
	if _room == Room.Room_Type.COMBAT:
		room_count += 1
		spawn_active = true
		wait_next_spawn_delay = level.data.enemy_waves[active_spawn_id].delay_before_starting
		wait_next_spawn_timer_active = true


func _get_instantiated_enemy(_data:EnemyData, _list:Array[Enemy2D]) -> Enemy2D:
	for enemy in _list:
		if enemy != null and enemy.enemy_data != null and enemy.enemy_data.id == _data.id:
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
	#print("not spawn_active: ", not spawn_active, " and all_enemies.is_empty(): ", all_enemies.is_empty())
	if not spawn_active and all_enemies.is_empty():
		Signals.RoomClear.emit()


func _return_to_pool(_enemy:Enemy2D) -> void:
	var in_pool:bool = false
	for each in enemy_pool:
		if not each.is_empty() and each[0].data.id == _enemy.data.id:
			each.append(_enemy)
			in_pool = true
			break
	
	if not in_pool:
		enemy_pool.append([_enemy])

	_remove_enemy_from_all(_enemy)
	room.remove_child.call_deferred(_enemy)


func _clear_spawner() -> void:
	for pool in enemy_pool:
		for each in pool:
			each.queue_free.call_deferred()
	enemy_pool.clear()
	for each in all_enemies:
		each.queue_free.call_deferred()
	all_enemies.clear()


func _get_amount_of_waves() -> int:
	if room_count > level.data.enemy_waves.size() and room_count <= level.data.enemy_waves.size() * level.data.enemy_waves.size():
		return ceili(room_count/level.data.enemy_waves.size())
	elif room_count > level.data.enemy_waves.size() * level.data.enemy_waves.size():
		return level.data.enemy_waves.size()
	return 1


func _get_enemy_level() -> int:
	if room_count > 2:
		return ceili(room_count/2)
	return 1


func _get_spawn_point(_room:Room, _player:SyCharacterBody2D) -> Vector2:
	var found:bool = false
	var result:Vector2
	while not found:
		result = Vector2(randi_range(SPAWN_AREA[0], SPAWN_AREA[1]), randi_range(SPAWN_AREA[2], SPAWN_AREA[3]))
		if result.distance_squared_to(_room.to_local(_player.global_position)) > DISTANCE_MIN:
			found = true
	#print("Enemy spawn pos: ", result)
	return result